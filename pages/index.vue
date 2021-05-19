<template>
  <div>
    <b-card no-body class="mt-5" style="padding: 10px">
      <div id="main">
        <!-- filters -->
        <b-row class="mb-3">
          <b-col lg="12" md="8" sm="8" class="mb-3 mt-2">
            <b-button
              id="add-btn"
              variant="success"
              size="sm"
              class="main-button"
              @click="showAddModal"
            >
              <font-awesome-icon
                style="color:white"
                icon="plus"
                small
                class="icon"
              />Add Employee Working CICD x2!
            </b-button>
          </b-col>

          <b-col cols="5" lg="5" md="5" sm="5" class="mb-2">
            <b-input-group>
              <b-form-input
                size="sm"
                maxlength="10"
                type="search"
                placeholder="Search Employee"
                id="search-all"
                v-model="filter"
                autocomplete="off"
              ></b-form-input>
              <b-input-group-append>
                <b-button
                  id="clear-search"
                  size="sm"
                  :disabled="!filter"
                  @click="filter = ''"
                  >Clear</b-button
                >
              </b-input-group-append>
            </b-input-group>
          </b-col>
          <b-col cols="5" lg="5" md="5" sm="5" class="mb-2">
            <!-- dummy column -->
          </b-col>
          <b-col cols="2" lg="2" md="2" sm="3" class="items">
            <b-input-group prepend="Items" size="sm">
              <b-form-select style="z-index:0" size="sm" v-model="perPage">
                <option v-for="value in values" :key="value" :value="value">{{
                  value
                }}</option>
                <option :value="filterItems.length">All</option>
              </b-form-select>
            </b-input-group>
          </b-col>
        </b-row>
        <!-- end filters -->

        <!-- table -->
        <b-table
          class="mt-2"
          ref="display-items-table"
          id="display-items-table"
          :borderless="false"
          :items="filterItems"
          :filter="filter"
          :fields="fields"
          :busy="isBusy"
          selectedVariant="primary"
          responsive
          show-empty
          :per-page="perPage"
          :current-page="currentPage"
          sort-by="lastModify"
          :sort-asc="true"
        >
          <template v-slot:table-busy>
            <div class="text-center text-secondary my-2">
              <b-spinner small class="align-middle"></b-spinner>
              <strong>&nbsp;Loading...</strong>
            </div>
          </template>
          <template v-slot:table-caption>{{ bottomLabel }}</template>

          <!-- buttons -->
          <template v-slot:cell(actions)="row">
            <!--  -->
            <b-button
              id="edit-btn"
              size="sm"
              class="mr-1 table-button"
              v-b-tooltip.hover
              @click="showUpdateModal(row)"
              title="Edit"
            >
              <font-awesome-icon
                style="color:white"
                icon="edit"
                small
                class="icon"
              />
            </b-button>
          </template>
        </b-table>
        <!-- end table -->

        <!-- pagination -->
        <div class="mt-5">
          <b-pagination
            v-if="filterItems.length !== 0"
            id="pagination"
            align="center"
            v-model="currentPage"
            :total-rows="totalRows"
            :per-page="perPage"
            class="my-0"
            size="sm"
            pills
          ></b-pagination>
        </div>
        <!-- end pagination -->

        <!-- add modal -->
        <b-modal
          header-bg-variant="success"
          header-text-variant="light"
          title="Add Employee"
          @hidden="clearAdd"
          @hide="clearAdd"
          v-model="isAdd"
          v-if="toAdd"
          no-close-on-backdrop
        >
          <b-card class="card-shadow">
            <!--  -->
            <b-form-group>
              <label class="mb-1">First Name</label>
              <b-form-input
                id="input-fn"
                v-model="toAdd.firstName"
                class="mb-1"
                autocomplete="off"
              ></b-form-input>
            </b-form-group>
            <!--  -->
            <b-form-group>
              <label class="mb-1">Last Name</label>
              <b-form-input
                id="input-ln"
                v-model="toAdd.lastName"
                class="mb-1"
                autocomplete="off"
              ></b-form-input>
            </b-form-group>
            <!--  -->
            <b-form-group>
              <label class="mb-1">Age</label>
              <b-form-input
                id="input-age"
                type="number"
                v-model="toAdd.age"
                class="mb-1"
                autocomplete="off"
              ></b-form-input>
            </b-form-group>
          </b-card>
          <template v-slot:modal-footer="{}">
            <b-button
              size="sm"
              variant="success"
              @click="addEmployee"
              class="main-button function-button"
              >Add</b-button
            >
            <b-button
              size="sm"
              class="main-button function-button"
              style="border: 0px;"
              @click="clearAdd"
              >Cancel</b-button
            >
          </template>
        </b-modal>
        <!-- end add modal -->

        <!-- update modal -->
        <b-modal
          header-bg-variant="success"
          header-text-variant="light"
          title="Update Employee"
          @hidden="clearUpdate"
          @hide="clearUpdate"
          v-model="isUpdate"
          v-if="toUpdate"
          no-close-on-backdrop
        >
          <b-card class="card-shadow">
            <!--  -->
            <b-form-group>
              <label class="mb-1">First Name</label>
              <b-form-input
                id="input-fn"
                v-model="toUpdate.firstName"
                class="mb-1"
                autocomplete="off"
              ></b-form-input>
            </b-form-group>
            <!--  -->
            <b-form-group>
              <label class="mb-1">Last Name</label>
              <b-form-input
                id="input-ln"
                v-model="toUpdate.lastName"
                class="mb-1"
                autocomplete="off"
              ></b-form-input>
            </b-form-group>
            <!--  -->
            <b-form-group>
              <label class="mb-1">Age</label>
              <b-form-input
                id="input-age"
                type="number"
                v-model="toUpdate.age"
                class="mb-1"
                autocomplete="off"
              ></b-form-input>
            </b-form-group>
          </b-card>
          <template v-slot:modal-footer="{}">
            <b-button
              size="sm"
              variant="success"
              @click="updateEmployee"
              class="main-button function-button"
              >Update</b-button
            >
            <b-button
              size="sm"
              class="main-button function-button"
              style="border: 0px;"
              @click="clearUpdate"
              >Cancel</b-button
            >
          </template>
        </b-modal>
        <!-- end update modal -->
      </div>
    </b-card>
  </div>
</template>

<script>
import axios from "axios";
import moment from "moment";

export default {
  head() {
    return {
      title: `Clean App`,
      meta: [
        {
          hid: "Clean App",
          name: "Clean App",
          content: "Clean App"
        }
      ]
    };
  },
  components: {},
  data() {
    return {
      showLoading: false,
      //   for table
      filter: null,
      perPage: 5,
      values: ["5", "10", "25", "50", "100"],
      items: [],
      currentPage: 1,
      isBusy: false,
      fields: [
        {
          key: "lastModify",
          label: "Last Modified",
          sortable: true
        },
        {
          key: "fullName",
          label: "Full Name",
          sortable: true
        },
        {
          key: "age",
          label: "Age",
          sortable: true
        },
        {
          key: "actions",
          label: "Actions"
        }
      ],
      totalRows: null,
      //   end for table
      windowWidth: window.innerWidth,
      toAdd: null, // object to insert
      isAdd: false, // to trigger add modal
      toUpdate: null, // object to update
      isUpdate: false, // to trigger update modal
      fundTypes: [] // hold fund types
    };
  },
  mounted() {
    window.addEventListener("resize", () => {
      this.windowWidth = window.innerWidth;
    });
  },
  async created() {
    this.getEmployees();
  },
  methods: {
    async updateEmployee() {
      try {
        this.showLoading = true;
        const res = await axios({
          method: "PATCH",
          url: `${this.$axios.defaults.baseURL}/employees/${this.toUpdate.id}`,
          auth: {
            username: process.env.userName,
            password: process.env.pw
          },
          data: {
            ...this.toUpdate
          }
        });
        this.showLoading = false;

        const msg = res.data.patched;
        this.showMessage(msg, "success", "Success");

        // clear data; close modal and reload table;
        this.clearUpdate();

        // web socket to update table
      } catch (e) {
        console.log("Error on update: ", e);
        if (e.response.data) {
          this.showLoading = false;
          let err = e.response.data.error;
          this.showMessage(err, "danger", "Error");
        }
      }
    },
    clearUpdate() {
      this.toUpdate = null;
      this.isUpdate = false;
    },
    showUpdateModal(row) {
      const data = row.item;
      this.toUpdate = {
        id: data.id,
        firstName: data.firstName,
        lastName: data.lastName,
        age: data.age
      };
      this.isUpdate = true;
    },
    async addEmployee() {
      try {
        this.showLoading = true;
        const res = await axios({
          method: "POST",
          url: `${this.$axios.defaults.baseURL}/employees`,
          auth: {
            username: process.env.userName,
            password: process.env.pw
          },
          data: {
            ...this.toAdd
          }
        });
        this.showLoading = false;

        const msg = res.data.posted;
        this.showMessage(msg, "success", "Success");

        // clear data; close modal and reload table;
        this.clearAdd();

        // web socket to append new added data
      } catch (e) {
        console.log("Error on adding: ", e);
        if (e.response.data) {
          this.showLoading = false;
          let err = e.response.data.error;
          this.showMessage(err, "danger", "Error");
        }
      }
    },
    clearAdd() {
      this.toAdd = null;
      this.isAdd = false;
    },
    showAddModal() {
      this.toAdd = {
        firstName: null,
        lastName: null,
        age: 0
      };
      this.isAdd = true;
    },
    async getEmployees() {
      try {
        this.isBusy = true;
        const res = await axios({
          method: "GET",
          url: `${this.$axios.defaults.baseURL}/employees`,
          auth: {
            username: process.env.userName,
            password: process.env.pw
          }
        });

        const data = res.data.view;
        // clear array
        this.items = [];
        for (let i = 0; i < data.length; i++) {
          const e = data[i];
          this.items.push({
            lastModify: moment(e.updatedAt).format(`MMM DD, YYYY hh:mm A`),
            id: e.id,
            firstName: e.firstName,
            lastName: e.lastName,
            age: e.age,
            fullName: `${e.firstName} ${e.lastName}`
          });
        }
        this.isBusy = false;
      } catch (e) {
        console.log("Error fetch: ", e);
        if (e.response.data) {
          let err = e.response.data;
          this.showMessage(err, "danger", "Error");
        }
      }
    },
    showMessage(msg, variant, title) {
      this.$bvToast.toast(`${msg}`, {
        title: title,
        toaster: "b-toaster-bottom-right",
        solid: true,
        variant: variant,
        appendToast: true
      });
    }
  },
  computed: {
    filterItems() {
      // this will search thru every property per object in array
      const items = this.items.filter(e => {
        if (this.filter) {
          const bool = Object.keys(e).some(k => {
            let str = e[k];
            str = str.toString();
            const check = str.toLowerCase().includes(this.filter.toLowerCase());
            return check;
          });

          return bool;
        } else {
          return true;
        }
      });

      this.totalRows = items.length;

      return items;
    },
    bottomLabel() {
      let end = this.perPage * this.currentPage;
      let start = end - this.perPage + 1;

      if (end > this.filterItems.length) {
        end = this.filterItems.length;
      }
      if (this.filterItems.length === 0) {
        start = 0;
      }
      return `Showing ${start} to ${end} of ${this.filterItems.length} entries`;
    }
  }
};
</script>

<style></style>

# build stage
FROM node:10-alpine as build-stage
WORKDIR /usr/src/app
COPY package*.json ./

RUN apk update
RUN apk add --no-cache git

RUN npm install --only=prod
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
RUN rm /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
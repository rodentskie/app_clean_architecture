#!/bin/bash

# function to read value from .env file
read_var() {
    if [ -z "$1" ]; then
        echo "Please enter the environment variable to read!"
        return 1
    fi

    local ENV_FILE='.env'
    if [ ! -z "$2" ]; then
        ENV_FILE="$2"
    fi

    local VAR=$(grep $1 "$ENV_FILE" | xargs)
    IFS="=" read -ra VAR <<<"$VAR"
    echo ${VAR[1]}
}

# build the app
npm run build

# read value from .env
SERVER_USER=$(read_var SERVER_USER)
SERVER_IP=$(read_var SERVER_IP)
DEPLOY_DIRECTORY=$(read_var DEPLOY_DIRECTORY)

# generate full creds
FULL_CREDS="${SERVER_USER}@${SERVER_IP}:${DEPLOY_DIRECTORY}/app"

# scp files to server
scp -r dist/ Dockerfile default.conf .env $FULL_CREDS

# ssh and run shellscript to deploy
ssh "${SERVER_USER}@${SERVER_IP}" "cd ${DEPLOY_DIRECTORY}; sudo -S docker-compose up -d --no-deps --build app;"

# delete dist folder
rm -rf dist
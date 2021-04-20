#!/bin/bash
npm run build

# scp files to server
scp -r dist/ Dockerfile default.conf .env root@128.199.183.222:/opt/spttms/app_spttms

# ssh and run shellscript to deploy
ssh root@128.199.183.222 "cd /opt/spttms; ./deploy-app.sh"

# delete dist folder
rm -rf dist
FROM node:14.16.0-alpine

RUN apk update && npm install -g @vue/cli

WORKDIR /study_management_app_front

COPY package.json /study_management_app_front/package.json
COPY package-lock.json /study_management_app_front/package-lock.json
RUN npm install
COPY . ./study_management_app_front
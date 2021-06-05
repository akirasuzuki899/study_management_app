FROM node:14.16.0-alpine

WORKDIR /app

RUN apk update && npm install -g create-nuxt-app
COPY package.json /study_management_app_front/package.json
COPY package-lock.json /study_management_app_front/package-lock.json
RUN npm install

COPY . ./app

EXPOSE 8080
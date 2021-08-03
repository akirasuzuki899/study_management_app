FROM node:14.16.0-alpine

WORKDIR /front

RUN apk update && npm install -g create-nuxt-app
COPY package.json /package.json
COPY package-lock.json /package-lock.json
RUN npm install

COPY . ./

EXPOSE 8080
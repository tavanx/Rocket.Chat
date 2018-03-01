FROM node:8-slim

MAINTAINER alex.zhang@tavanv.com

RUN groupadd -r rocketchat \
&&  useradd -r -g rocketchat rocketchat \
&&  mkdir -p /app/uploads \
&&  chown rocketchat.rocketchat /app/uploads

VOLUME /app/uploads

ENV RC_VERSION 0.61.2

WORKDIR /app

RUN npm install --registry=https://registry.npm.taobao.org \
    &&  && npm cache clear --force

USER rocketchat

WORKDIR /app/server

# needs a mongoinstance - defaults to container linking with alias 'db'
ENV DEPLOY_METHOD=docker-official \
    MONGO_URL=mongodb://db:27017/meteor \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
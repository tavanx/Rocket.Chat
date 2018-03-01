FROM node:8-slim

ENV RC_VERSION 0.62.0-rc.4

MAINTAINER alex.zhang@tavanv.com

COPY ./releases /app

RUN groupadd -r rocketchat \
&&  useradd -r -g rocketchat rocketchat \
&&  mkdir -p /app/uploads \
&&  chown rocketchat.rocketchat /app/uploads

VOLUME /app/uploads

WORKDIR /app

RUN npm install bcrypt -g

RUN set -x \
 && cd /app/bundle/programs/server \
 && npm install --registry=https://registry.npm.taobao.org \
 && npm cache clear --force \
 && chown -R rocketchat:rocketchat /app

USER rocketchat

WORKDIR /app/bundle

# needs a mongoinstance - defaults to container linking with alias 'db'
ENV DEPLOY_METHOD=docker \
    NODE_ENV=production \
    MONGO_URL=mongodb://mongo:27017/rocketchat \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
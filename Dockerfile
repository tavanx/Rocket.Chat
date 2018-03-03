FROM rocketchat/base:8

MAINTAINER buildmaster@rocket.chat

RUN mkdir -p /app
COPY ./releases/Rocket.Chat.tar.gz /app

RUN set -x \
 && tar -xf /app/Rocket.Chat.tar.gz -C /app \
 && cd /app/bundle/programs/server \
 && npm install \
#  && npm cache clear --force \
 && chown -R rocketchat:rocketchat /app

USER rocketchat

VOLUME /app/uploads

WORKDIR /app/bundle

# needs a mongoinstance - defaults to container linking with alias 'mongo'
ENV DEPLOY_METHOD=docker \
    NODE_ENV=production \
    MONGO_URL=mongodb://mongo:27017/rocketchat \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
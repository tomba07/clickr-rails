FROM node:lts-alpine

ENV NODE_ENV=production
WORKDIR /app

RUN apk add --no-cache \
  g++ \
  git \
  linux-headers \
  make \
  python

COPY package.json .
COPY yarn.lock .

RUN yarn install --production --frozen-lockfile

COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

VOLUME /repository

CMD ["yarn", "balena", "push", "clickr", "-s", "/repository"]

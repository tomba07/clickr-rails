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

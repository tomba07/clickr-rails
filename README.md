# Clickr

## Overview
```
$ tree -L 2 --filelimit 10 --dirsfirst
.
├── bin
│   ├── docker-build
│   ├── docker-run
│   ├── docker-template
│   ├── list-devices
│   ├── release-to-pi
│   ├── setup-environment-variables
│   └── show-device-info
├── node_modules [805 entries exceeds filelimit, not opening dir]
├── services
│   ├── rfid-keyboard-reader
│   └── web
├── docker-compose.yml
├── package.json
├── README.md
└── yarn.lock
```

- `bin` contains development scripts
- `services` contains services which can be bundled as docker images (e.g. the rails web app and hardware connectors)
- `docker-compose.yml` defines how to run those services together

## Getting started
1. `yarn install`
2. `bin/setup-environment-variables <rails-master-key>`
3. `cd services/web`
4. `bundle install`
5. `bundle exec rails db:create db:migrate db:seed`
6. `rails s`
7. `xdg-open http://localhost:80`, credentials: `f@ftes.de`/`password`

## Docker
1. `yarn install && bin/setup-environment-variables <rails-master-key>` (if you haven't done so already)
2. `./bin/docker-build` (build locally first, that's faster, but not for ARM/Raspberry Pi)
3. `./bin/release-to-pi` (balena.io cloud build and push to devices)

## Balena cloud configuration
Initialized via `bin/setup-environment-variables`.
- `RAILS_MASTER_KEY`: decryption key for secrets
- `RFID_KEYBOARD_READER_USB_IDS`: comma-separated list USB IDs `<vendor>:<product>` for RFID readers acting as keyboards (e.g. `16c0:27db`)
- `RFID_KEYBOARD_READER_DEBOUNCE_SECONDS`: number of seconds to wait before RFID token is read again (debounce)

## TODO
- `web`: [balena update locking](https://www.balena.io/docs/learn/deploy/release-strategy/update-locking/) and trigger from within the app (do not update during lesson)
- new adapters (e.g. raw I/O)
- `rfid-keyboar-reader`: support selecting by device.name (`HXGCoLtd Keyboard`)
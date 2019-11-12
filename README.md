# Clickr

## Overview
```
$ tree -L 2
.
├── bin
│   ├── docker-build
│   ├── docker-run
│   ├── docker-template
│   ├── release-to-pi
│   └── setup-rails-master-key
├── docker-compose.yml
├── README.md
└── services
    └── web
```

- `bin` contains development scripts
- `services` contains services which can be bundled as docker images (e.g. the rails web app and hardware connectors)
- `docker-compose.yml` defines how to run those services together

## Getting started
1. `yarn install`
2. `bin/setup-rails-master-key <master-key>`
3. `cd services/web`
4. `bundle install`
5. `bundle exec rails db:create db:migrate db:seed`
6. `rails s`
7. `xdg-open http://localhost:80`, credentials: `f@ftes.de`/`password`

## Docker
1. `yarn install && bin/setup-rails-master-key <master-key>` (if you haven't done so already)
2. `./bin/docker-build` (build locally first, that's faster, but not for ARM/Raspberry Pi)
3. `./bin/release-to-pi` (balena.io cloud build and push to devices)

## Balena cloud configuration
- `RAILS_MASTER_KEY`: Set via `bin/setup-rails-master-key`
- `RFID_KEYBOARD_READER_USB_IDS`: comma-separated list USB IDs `<vendor>:<product>` for RFID readers acting as keyboards (e.g. `16c0:27db`)

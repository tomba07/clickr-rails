# Clickr
[![Travis services/web build Status](https://travis-ci.com/ftes/clickr-rails.svg?branch=master)](https://travis-ci.com/ftes/clickr-rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/2e8f539b798959baf7e9/maintainability)](https://codeclimate.com/github/ftes/clickr-rails/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2e8f539b798959baf7e9/test_coverage)](https://codeclimate.com/github/ftes/clickr-rails/test_coverage)

## Introduction
TODO briefly explain domain model

## Tech Stack
Languages, frameworks and libraries:
- web service:
    - Ruby
    - Rails (webpacker, stimulus)
    - SQLite
    - Devise gem (authentication)
    - bulma (styling)
    - fontawesome (icons)
- input adapters:
    - python

Build/CI/Deployment:
- docker and docker-compose
- Travis (run tests, push code coverage results to Codeclimate, build and push AMD64 amd ARM64 docker images, deploy master branch to heroku, trigger balena.io build and deploy)
- Codeclimate (code quality)
- balena.io (build ARM docker image, manage devices)

## Concepts

### Incomplete student-device-mapping
An incomplete mapping is helpful when setting up a new school class.
A lot of new students are created and need to be mapped to devices.

Technically, students and incomplete mappings (without a device ID) are created.

When a new click is registered, and
1. that device is not yet mapped
2. at least one incomplete mapping exists

then the oldest incomplete mapping is updated with that device ID.
So, effectively, the first student that is not yet mapped is now mapped to that device.

## Technical overview
```
$ tree -L 2 --filelimit 10 --dirsfirst
.
├── bin
│   ├── docker-build
│   ├── docker-template
│   ├── docker-test
│   ├── list-devices
│   ├── release-to-pi
│   ├── setup-environment-variables
│   └── show-device-info
├── build
│   └── balena-cli
├── services
│   ├── rfid-keyboard-reader
│   └── web
├── docker-compose.yml
└── README.md
```

- `bin` contains development scripts
- `buiild/balena-cli` contains a docker image capable of performing balena push commands (TODO replace with simpler git push)
- `services` contains services which can be bundled as docker images (e.g. the rails web app and hardware connectors)
- `docker-compose.yml` defines how to run those services together (TODO multi pi setup -> several applications)

## Getting started
1. `yarn install --cwd build/balena-cli`
2. `bin/setup-environment-variables <rails-master-key>`
3. `cd services/web`
4. `bundle install`
5. `bundle exec rails db:create db:migrate db:seed`
6. `rails s`
7. `xdg-open http://localhost:80`, credentials: `f@ftes.de`/`password`

## Docker
1. `yarn install --cwd build/balena-cli && bin/setup-environment-variables <rails-master-key>` (if you haven't done so already)
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
- `web`: check that created_at indexes are used (order by desc)

## Configuration
App environment variables:
- `CLICKR_SUGGEST_NEW_LESSON_AFTER_MINUTES`: default `120`
- `CLICKR_SHOW_VIRTUAL_BUTTONS_LINK`: default `false` (in `RAILS_ENV=development` default `true`)

## Heroku setup
One-time database setup:
```sh
heroku run sh --type=worker
$ bundle exec rails db:create db:migrate db:seed
```

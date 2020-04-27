# Clickr
[![Travis services/web build Status](https://travis-ci.com/ftes/clickr-rails.svg?branch=master)](https://travis-ci.com/ftes/clickr-rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/2e8f539b798959baf7e9/maintainability)](https://codeclimate.com/github/ftes/clickr-rails/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2e8f539b798959baf7e9/test_coverage)](https://codeclimate.com/github/ftes/clickr-rails/test_coverage)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

**Designed to motivate: A student response system for schools.**

**For teachers:**
- Give oral grades based on the response data, rather than a gut feeling.
- Spend no more taking notes on student participation after or during each lesson. 

**For students:**
- See how your participation immediately improves your oral grade.


## Overview
What clickr is:
- Rasperry Pi in class room (all data stays local) connected to projector
- Each student has a physical button (zigbee)
- Live view (via browser): teacher starts a question, students register their response by clicking the button

What clickr is not (yet):
- Multiple choice response system: Students only register a "binary" response: Do I know the answer or not. 

## Tech Stack
- **Web app:** Ruby on Rails, PostgreSQL
- **Input adapter:** Node.js, [zigbee-herdsman](https://github.com/Koenkk/zigbee-herdsman)
- **CI/CD:** TravisCI, heroku (cloud preview) [balena.io](https://www.balena.io/) (embedded device management)

## Technical overview
```
$ tree -L 2 --filelimit 12 --dirsfirst
.
├── bin
├── services
│   ├── web
│   └── zstack-zigbee-reader
├── docker-compose.yml
```

- `bin` contains development scripts
- `services` contains services which can be bundled as docker images (e.g. the rails web app and hardware connectors)
- `docker-compose.yml` defines how to run those services together

## Getting started
1. `npm i`
3. `cd services/web`
4. `bundle install`
5. `bundle exec rails db:create db:migrate db:seed`
6. `rails s`
7. `xdg-open http://localhost:3000`, credentials: `f@ftes.de`/`password`

## Docker
1. `yarn install && bin/setup-environment-variables <rails-master-key>` (if you haven't done so already)
2. `./bin/docker-build` (build locally to test everything is fine first)
3. `npm run balena:push` (balena.io cloud build and push to devices)

## Balena cloud configuration
Initialized via `bin/setup-environment-variables`.

## Configuration
App environment variables:
- `RAILS_MASTER_KEY`: decryption key for secrets
- `CLICKR_SUGGEST_NEW_LESSON_AFTER_MINUTES`: default `120`
- `CLICKR_SHOW_VIRTUAL_BUTTONS_LINK`: default `false` (in `RAILS_ENV=development` default `true`)
- `CLICKR_BENCHMARK_BUFFER`: how high you can set the lesson benchmark compared to the best student, default `5`
- `CLICKR_INITIAL_STUDENT_RESPONSE_PERCENTAGE`: influences the grade, practically a virtual first lesson, default `77`
- `CLICKR_STUDENT_ABSENT_IF_LESSON_SUM_LESS_THAN_OR_EQUAL_TO`: threshold when to consider student absent
  - absent students are ignored in the class lesson average
  - lessons in which the student was absent are ignored in his average grade
- `CLICKR_ROLL_THE_DICE_DURATION_MS`: How long should the animation for selecting a student (roll the dice) take overall in milliseconds, default `3000`
- `ZSTACK_ZIGBEE_DEVICE`: default `/dev/ttyACM0`
- `ZSTACK_ZIGBEE_PERMIT_JOIN`: default `true`
- `ZSTACK_ZIGBEE_PAN_ID`: default `0x1a63`
- `ZSTACK_ZIGBEE_EXTENDED_PAN_ID`: default `0x62c089def29a0295`
- `ZSTACK_ZIGBEE_NETWORK_KEY`: default `0x44a6a5fbe41d8844ac7f0778a261f9c5`
- `ZSTACK_ZIGBEE_CHANNEL`: default `11` (Note: use a ZLL channel: 11, 15, 20, or 25 to avoid Problems)

## Heroku setup
One-time database setup:
```sh
heroku run sh --type=worker
$ bundle exec rails db:create db:migrate db:seed
```

## Concepts
<!-- TODO Describe concepts as ADR (architecture decision records), remove them from README -->

### Incomplete student-device-mapping
An incomplete mapping is helpful when setting up a new school class.
A lot of new students are created and need to be mapped to devices.

Technically, students and incomplete mappings (without a device ID) are created.

When a new click is registered, and
1. that device is not yet mapped
2. at least one incomplete mapping exists

then the oldest incomplete mapping is updated with that device ID.
So, effectively, the first student that is not yet mapped is now mapped to that device.

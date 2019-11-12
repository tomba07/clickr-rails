# README

## Getting started
1. `bundle install`
2. `bundle exec rails db:create db:migrate db:seed`
3. `rails s`
4. `xdg-open http://localhost:3000`, credentials: `f@ftes.de`/`password`

## Docker
- `./bin/docker-build`
- `./bin/release-to-pi` (balena.io cloud build and push to devices)

## Provising the master key
- `RAILS_MASTER_KEY=<master-key>`

The file `config/master.key` is not added to the repository and docker image.
It must be manually provisioned (via an environment variable).

It seems to also be required during asset:precompile, so consider setting in the `.env` file, too.
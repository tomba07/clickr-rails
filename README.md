# README

## Getting started
1. `bundle install`
2. `bin/setup-rails-master-key <master-key>`
3. `bundle exec rails db:create db:migrate db:seed`
4. `rails s`
5. `xdg-open http://localhost:3000`, credentials: `f@ftes.de`/`password`

## Docker
1. `bin/setup-rails-master-key <master-key>` (if you haven't done so already)
2. `./bin/docker-build` (build locally first, that's faster, but not for ARM/Raspberry Pi)
3. `./bin/release-to-pi` (balena.io cloud build and push to devices)

## Rails master key
Set `RAILS_MASTER_KEY`:
- For development (either `.env` file or in `config/master.key`)
- For CI build server (`.balena/balena.yml`)
- On devices (via balena fleet management UI -> environment variables)

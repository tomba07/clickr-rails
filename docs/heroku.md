# Running clickr on Heroku

The clickr/web service is deployed to heroku for demo purposes.
 
It uses a heroku `container` stack.

The docker image is updated by TravisCI via the heroku formation API (see [heroku-release](../bin/heroku-release)).


## One-time database setup
```sh
heroku run sh --type=worker
$ bundle exec rails db:create db:migrate db:seed
```

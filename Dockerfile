FROM alpine:latest

RUN apk add --no-cache \
  build-base \
  ruby-dev \
  ruby-bundler \
  ruby-json \
  sqlite-dev \
  # Timezone information
  tzdata \
  yarn \
  # For nokogiri gem
  zlib-dev

RUN mkdir -p "/usr/src/app"
WORKDIR /usr/src/app

COPY Gemfile .
COPY Gemfile.lock .
# TODO RPi: --without development test
RUN bundle install

COPY package.json .
COPY yarn.lock .
RUN yarn install

COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# TODO puma
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

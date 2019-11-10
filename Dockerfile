# TODO switch to alpine (get rid of /bin/bash -l -c)
FROM debian

RUN apt-get update && apt-get install -yq --no-install-recommends \
    ca-certificates \
    curl \
    libpq-dev \
    nodejs \
    postgresql-client \
    procps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# install RVM, Ruby, and Bundler
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.6.3"
RUN /bin/bash -l -c "gem install bundler"

RUN \curl -o- -L https://yarnpkg.com/install.sh | bash

#switch on systemd init system in container
ENV INITSYSTEM on

RUN mkdir -p "/usr/src/app"
WORKDIR /usr/src/app

COPY Gemfile .
COPY Gemfile.lock .
# TODO RPi: --without development test
RUN /bin/bash -l -c "bundle install"

COPY package.json .
COPY yarn.lock .
RUN /bin/bash -l -c "yarn install"

COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# TODO puma
CMD ["/bin/bash", "-l", "-c", "'bundle exec rails server -b 0.0.0.0'"]

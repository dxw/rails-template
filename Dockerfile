FROM ruby:2.7.2 as release
MAINTAINER dxw <rails@dxw.com>

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -qq -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  shellcheck \
  --fix-missing --no-install-recommends

ENV INSTALL_PATH /srv/app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

# set rails environment
ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV:-production}
ENV RACK_ENV=${RAILS_ENV:-production}

COPY Gemfile $INSTALL_PATH/Gemfile
COPY Gemfile.lock $INSTALL_PATH/Gemfile.lock

RUN gem update --system
RUN gem install bundler

# bundle ruby gems based on the current environment, default to production
RUN echo $RAILS_ENV
RUN \
  if [ "$RAILS_ENV" = "production" ]; then \
    bundle install --without development test --retry 10; \
  else \
    bundle install --retry 10; \
  fi

COPY . $INSTALL_PATH

RUN RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE="super secret" bundle exec rake assets:precompile --quiet

# TODO:
# In order to expose the current git sha & time of build in the /healthcheck
# endpoint, pass these values into your deployment script, for example:
# --build-arg current_sha="$GITHUB_SHA" \
# --build-arg time_of_build="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
ARG current_sha
ARG time_of_build

ENV CURRENT_SHA=$current_sha
ENV TIME_OF_BUILD=$time_of_build

# db setup
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server"]

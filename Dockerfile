# ------------------------------------------------------------------------------
# Base
# ------------------------------------------------------------------------------
FROM ruby:2.7.4 as base
MAINTAINER dxw <rails@dxw.com>

RUN curl -L https://deb.nodesource.com/setup_16.x | bash -
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y --fix-missing --no-install-recommends \
  build-essential \
  libpq-dev

ENV APP_HOME /srv/app
ENV DEPS_HOME /deps

ARG RAILS_ENV
ENV RAILS_ENV ${RAILS_ENV:-production}
ENV NODE_ENV ${RAILS_ENV:-production}

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------
FROM base AS dependencies

RUN mkdir -p ${DEPS_HOME}
WORKDIR $DEPS_HOME

RUN apt-get update && apt install -y yarn

# Install Javascript dependencies
COPY yarn.lock $DEPS_HOME/yarn.lock
COPY package.json $DEPS_HOME/package.json
RUN yarn install

# Install Ruby dependencies
COPY Gemfile $DEPS_HOME/Gemfile
COPY Gemfile.lock $DEPS_HOME/Gemfile.lock
RUN gem update --system
RUN gem install bundler -v 2.2.16

ENV BUNDLE_GEM_GROUPS=$RAILS_ENV
RUN bundle config set frozen "true"
RUN bundle config set no-cache "true"
RUN bundle config set with $BUNDLE_GEM_GROUPS
RUN bundle install --retry=10 --jobs=4

# ------------------------------------------------------------------------------
# Web
# ------------------------------------------------------------------------------
FROM dependencies AS web

RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

# Copy app code (sorted by vague frequency of change for caching)
RUN mkdir -p ${APP_HOME}/log
RUN mkdir -p ${APP_HOME}/tmp

COPY config.ru ${APP_HOME}/config.ru
COPY Rakefile ${APP_HOME}/Rakefile

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

COPY public ${APP_HOME}/public
COPY vendor ${APP_HOME}/vendor
COPY bin ${APP_HOME}/bin
COPY lib ${APP_HOME}/lib
COPY config ${APP_HOME}/config
COPY db ${APP_HOME}/db
COPY script ${APP_HOME}/script
COPY app ${APP_HOME}/app
# End

# Create tmp/pids
RUN mkdir -p tmp/pids

# This must be ordered before rake assets:precompile
RUN cp -R $DEPS_HOME/node_modules $APP_HOME/node_modules

RUN if [ "$RAILS_ENV" = "production" ]; then \
  RAILS_ENV="production" SECRET_KEY_BASE="secret" bundle exec rake assets:precompile; \
  fi

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

CMD ["bundle", "exec", "rails", "server"]

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------
FROM web as test

RUN apt-get update && apt-get install -y shellcheck

COPY package.json ${APP_HOME}/package.json
COPY yarn.lock ${APP_HOME}/yarn.lock

COPY .eslintignore ${APP_HOME}/.eslintignore
COPY .eslintrc.json ${APP_HOME}/.eslintrc.json
COPY .prettierignore ${APP_HOME}/.prettierignore
COPY .prettierrc ${APP_HOME}/.prettierrc

COPY .rspec ${APP_HOME}/.rspec
COPY spec ${APP_HOME}/spec

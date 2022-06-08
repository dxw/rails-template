# ------------------------------------------------------------------------------
# Base
# ------------------------------------------------------------------------------
FROM ruby:3.2.1 as base
LABEL org.opencontainers.image.authors="contact@dxw.com"

RUN curl -L https://deb.nodesource.com/setup_16.x | bash -
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

RUN \
  apt-get update && \
  apt-get install -y --fix-missing --no-install-recommends \
  build-essential \
  libpq-dev

ENV APP_HOME /srv/app
ENV DEPS_HOME /deps

ENV RAILS_ENV=production
ENV NODE_ENV=production

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------
FROM base AS dependencies

RUN apt-get update && apt-get install -y yarn

WORKDIR ${DEPS_HOME}

# Install Ruby dependencies
ENV BUNDLE_GEM_GROUPS ${RAILS_ENV}

COPY Gemfile ${DEPS_HOME}/Gemfile
COPY Gemfile.lock ${DEPS_HOME}/Gemfile.lock

RUN gem update --system 3.3.5
RUN gem install bundler -v 2.3.5
RUN bundle config set frozen "true"
RUN bundle config set no-cache "true"
RUN bundle config set without development test
RUN bundle install --retry=10 --jobs=4
# End

# Install Javascript dependencies
COPY yarn.lock ${DEPS_HOME}/yarn.lock
COPY package.json ${DEPS_HOME}/package.json

RUN yarn install --frozen-lockfile --production

# ------------------------------------------------------------------------------
# Production
# ------------------------------------------------------------------------------
FROM base AS production

WORKDIR ${APP_HOME}

# Copy dependencies (relying on dependencies using the same base image as this)
COPY --from=dependencies ${DEPS_HOME}/Gemfile ${APP_HOME}/Gemfile
COPY --from=dependencies ${DEPS_HOME}/Gemfile.lock ${APP_HOME}/Gemfile.lock
COPY --from=dependencies ${GEM_HOME} ${GEM_HOME}

COPY --from=dependencies ${DEPS_HOME}/package.json ${APP_HOME}/package.json
COPY --from=dependencies ${DEPS_HOME}/yarn.lock ${APP_HOME}/yarn.lock
COPY --from=dependencies ${DEPS_HOME}/node_modules ${APP_HOME}/node_modules
# End

# Copy app code (sorted by vague frequency of change for caching)
RUN mkdir -p ${APP_HOME}/log
RUN mkdir -p ${APP_HOME}/tmp

COPY config.ru ${APP_HOME}/config.ru
COPY Rakefile ${APP_HOME}/Rakefile
COPY script ${APP_HOME}/script
COPY public ${APP_HOME}/public
COPY vendor ${APP_HOME}/vendor
COPY bin ${APP_HOME}/bin
COPY config ${APP_HOME}/config
COPY lib ${APP_HOME}/lib
COPY db ${APP_HOME}/db
COPY app ${APP_HOME}/app
# End

# Create tmp/pids
RUN mkdir -p tmp/pids

RUN \
  if [ "$RAILS_ENV" = "production" ]; then \
  SECRET_KEY_BASE="secret" \
  bundle exec rake assets:precompile; \
  fi

# TODO:
# In order to expose the current git sha & time of build in the /healthcheck
# endpoint, pass these values into your deployment script, for example:
# --build-arg CURRENT_GIT_SHA="$GITHUB_SHA" \
# --build-arg TIME_OF_BUILD="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
ARG CURRENT_GIT_SHA
ARG TIME_OF_BUILD

ENV CURRENT_GIT_SHA ${CURRENT_GIT_SHA}
ENV TIME_OF_BUILD ${TIME_OF_BUILD}

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server"]

# ------------------------------------------------------------------------------
# Development
# ------------------------------------------------------------------------------
FROM production as development

ENV RAILS_ENV=development
ENV NODE_ENV=development

RUN bundle config unset without
RUN bundle config set with development
RUN bundle install --retry=10 --jobs=4

# Define the runtime command in docker-compose.yml
CMD ["bundle", "exec", "rails", "console"]

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------
FROM production as test

ENV RAILS_ENV=test
ENV NODE_ENV=test

RUN bundle config unset without
RUN bundle config set with test
RUN bundle install --retry=10 --jobs=4

RUN \
  apt-get update && \
  apt-get install -y \
  shellcheck \
  yarn

COPY .eslintignore ${APP_HOME}/.eslintignore
COPY .eslintrc.json ${APP_HOME}/.eslintrc.json
COPY .prettierignore ${APP_HOME}/.prettierignore
COPY .prettierrc ${APP_HOME}/.prettierrc
COPY .stylelintrc.json ${APP_HOME}/.stylelintrc.json
COPY .stylelintignore ${APP_HOME}/.stylelintignore

COPY .rspec ${APP_HOME}/.rspec
COPY spec ${APP_HOME}/spec

RUN yarn install --frozen-lockfile

# Define the runtime command in docker-compose.test.yml
CMD ["bundle", "exec", "rake"]

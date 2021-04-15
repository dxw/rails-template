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

# Install Javascript dependencies
COPY yarn.lock $INSTALL_PATH/yarn.lock
COPY package.json $INSTALL_PATH/package.json
RUN yarn install

# Install Ruby dependencies
COPY Gemfile $INSTALL_PATH/Gemfile
COPY Gemfile.lock $INSTALL_PATH/Gemfile.lock
RUN gem update --system
RUN gem install bundler

ENV BUNDLE_GEM_GROUPS=$RAILS_ENV
RUN bundle config set no-cache "true"
RUN bundle config set with $BUNDLE_GEM_GROUPS
RUN bundle install --retry=10 --jobs=4

# Copy app code (sorted by vague frequency of change for caching)
RUN mkdir -p ${INSTALL_PATH}/log
RUN mkdir -p ${INSTALL_PATH}/tmp

COPY config.ru ${INSTALL_PATH}/config.ru
COPY Rakefile ${INSTALL_PATH}/Rakefile

COPY /.eslintignore ${INSTALL_PATH}/.eslintignore
COPY .eslintrc.json ${INSTALL_PATH}/.eslintrc.json
COPY .prettierignore ${INSTALL_PATH}/.prettierignore
COPY .prettierrc ${INSTALL_PATH}/.prettierrc

COPY public ${INSTALL_PATH}/public
COPY vendor ${INSTALL_PATH}/vendor
COPY bin ${INSTALL_PATH}/bin
COPY lib ${INSTALL_PATH}/lib
COPY config ${INSTALL_PATH}/config
COPY db ${INSTALL_PATH}/db
COPY script ${INSTALL_PATH}/script
COPY app ${INSTALL_PATH}/app
# End

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

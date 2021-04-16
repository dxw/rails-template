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

RUN gem update --system --quiet
RUN gem install bundler

ARG BUNDLE_EXTRA_GEM_GROUPS
ENV BUNDLE_GEM_GROUPS=${BUNDLE_EXTRA_GEM_GROUPS:-"production"}
RUN bundle config set no-cache "true"
RUN bundle config set with $BUNDLE_GEM_GROUPS
RUN bundle install --no-binstubs --retry=3 --jobs=4

COPY . $INSTALL_PATH

RUN RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE="super secret" bundle exec rake assets:precompile --quiet

# db setup
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server"]

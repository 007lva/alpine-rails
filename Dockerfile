FROM alpine:3.2

MAINTAINER CenturyLink Labs <innovationslab@ctl.io>

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev postgresql-dev" \
    RUBY_PACKAGES="ruby ruby-io-console ruby-json yaml nodejs cmake bash" \
    RAILS_VERSION="4.2.3"

RUN \
  apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES && \
  gem install -N bundler

RUN gem install -N nokogiri -- --use-system-libraries && \
  gem install -N rails --version "$RAILS_VERSION" && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \

  # cleanup and settings
  bundle config --global build.nokogiri  "--use-system-libraries" && \
  bundle config --global build.nokogumbo "--use-system-libraries" && \
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem


RUN gem install byebug
RUN gem install database_cleaner
RUN gem install sqlite3
RUN gem install codeclimate-test-reporter
RUN gem install capybara
RUN gem install poltergeist
RUN gem install fuubar
RUN gem install rspec-rails
RUN gem install shoulda-matchers
RUN gem install guard-rspec
RUN gem install factory_girl_rails

# pronto integration
RUN apt-get update
RUN apt-get install -y cmake
RUN gem install pronto
RUN gem install pronto-rubocop
RUN gem install pronto-scss


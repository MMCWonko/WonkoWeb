FROM ubuntu:14.04

MAINTAINER Jan Dalheimer <jan@dalheimer.de>

# set up apt sources
RUN echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" | tee -a /etc/apt/sources.list && \
  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 && \
  apt-get update -qq

# install system and base ruby dependencies
RUN apt-get install -yqq build-essential libssl-dev ruby2.2 ruby2.2-dev nginx ca-certificates
RUN gem install --no-document bundler foreman

# preliminary setup
ENV APP_HOME /wonkoweb
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV ENV production
ENV RACK_ENV production
ENV RAILS_ENV production
EXPOSE 5000

# bundling (done before adding '.' for improved image caching)
COPY Gemfile* $APP_HOME/
RUN bundle install --without test development --deployment --jobs=3

ADD . $APP_HOME

RUN bundle install --without test development --deployment --jobs=3 && bundle exec rake assets:precompile

CMD bundle install --without test development --deployment --jobs=3 && \
  AIRBRAKE_KEY=$(bundle exec ruby server/get_errbit_api_key.rb) AIRBRAKE_HOST=$ERRBIT_PORT_4000_TCP_ADDR AIRBRAKE_PORT=$ERRBIT_PORT_4000_TCP_PORT \
  foreman start

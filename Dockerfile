FROM ruby:2.7.0

RUN apt-get update && apt-get install --yes --no-install-recommends \
  build-essential \
  libpq-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN mkdir /golcommu

ENV DATABASE_HOST db

ENV APP_ROOT /golcommu 
WORKDIR $APP_ROOT

COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install
COPY . $APP_ROOT
FROM ruby:2.7.0

RUN apt-get update -qq && \
  apt-get install -y build-essential \ 
  libpq-dev \        
  nodejs           

RUN gem install bundler

RUN mkdir /golcommu

ENV APP_ROOT /golcommu 
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install
ADD . $APP_ROOT
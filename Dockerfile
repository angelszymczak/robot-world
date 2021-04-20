FROM ruby:2.7.3

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

RUN mkdir -p /backend
WORKDIR /backend

COPY ./backend/Gemfile /backend
COPY ./backend/Gemfile.lock /backend

ENV BUNDLER_VERSION=2.2.16
RUN gem install bundler:2.2.16
RUN bundle install

COPY . /backend

RUN rm -f /backend/tmp/pids/server.pid

CMD rails server -b 0.0.0.0

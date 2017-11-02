FROM ruby:2.4.1

RUN apt-get update -qq \
  && apt-get install -y --fix-missing --no-install-recommends \
    build-essential \
    cron \
    curl \
    imagemagick \
    libxml2-dev \
    libxslt1-dev \
    tzdata \
  && apt-get clean

### Configure nokogiri
RUN bundle config build.nokogiri --use-system-libraries

### Install Nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
  && apt-get install -y nodejs

### Install mjml
RUN npm install -g mjml

ENV APP_HOME /usr/src/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

EXPOSE 3000

ENV BUNDLE_PATH /ruby_gems

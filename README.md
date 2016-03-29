# API Service Skeleton

API Service Skeleton serves as a template for any future API services build in Reevoo. It follows the
[Twelve Factor App](http://12factor.net/) guidelines.

## Technology stack

* [Puma](http://puma.io/) - Ruby web server
* [Grape](http://www.ruby-grape.org/) - framework for API services in Ruby
* [PostgreSQL](http://www.postgresql.org/) with [Sequel](http://sequel.jeremyevans.net/) - database layer
* [Grape Entity](https://github.com/ruby-grape/grape-entity) - API entities handling
* [RabbitMQ](http://www.rabbitmq.com/) with [Sneakers](http://jondot.github.io/sneakers/) - for async messaging
* [rv-logstasher](https://github.com/reevoo/logstasher) - logging (will be replaced by Reevoo Logger when ready)
* [Sentry](https://getsentry.com) with [Raven](https://github.com/getsentry/raven-ruby) - error tracking

### Dev tools

* [RSpec](http://rspec.info/) - testing framework
* [Capistrano](http://capistranorb.com/) - deployment tool (we plan to replace it by Kubernetes in future)

### You may also need

* [Unspeakable](https://github.com/reevoo/unspeakable) with [Speakeasy](https://github.com/reevoo/speakeasy) - secure storage (used mainly for customer emails)
* [Pony](https://github.com/benprew/pony) - emailing library
* [ElasticSearch](https://www.elastic.co/products/elasticsearch) with [Ruby client](https://github.com/elastic/elasticsearch-ruby) - for fulltext search
* [Client library for CP admin API](https://github.com/reevoo/client_portal_api_client_gem)
* [ruby-jwt](https://github.com/jwt/ruby-jwt) - library for handling JSON Web Tokens


All the required and optional gems are configured in the [Gemfile](Gemfile).



## Get the prerequisites:

For all the brew installs, remember to follow the instructions output in the console.

```bash
brew update
brew install postgresql # postgresql-9.4.0
brew install rabbitmq # only if you need async messaging

createdb # postgresql

# ruby-2.3.0
brew upgrade ruby-build
gem install bundler
bundle install
```

If you get asked which angular to install when you do the following, choose a 1.3.x version.

```bash
bower install
```

## Config setup
In the root directory:

```bash
cp .env.example .env
```

## Setup database

In the root directory:

```bash
bundle
createdb foo_service
bundle exec rake db:migrate
```

## Run it

```bash
bundle exec rackup
# or for code reloading during development
bundle exec shotgun
```

## Spec it:

```bash
# Ruby tests
bundle
createdb foo_service_test
RACK_ENV=test bundle exec rake db:migrate
rake
```

## Config

Config is set up with environment variables. To manage configuration in development and testing environment we use
(dotenv)[https://github.com/bkeepers/dotenv] library.
See the configuration variables required and the description for each one in [.env.example](.env.example).

## Deployment to staging

```bash
bundle exec cap staging deploy
```

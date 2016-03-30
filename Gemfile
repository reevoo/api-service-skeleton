source "https://gems.reevoocloud.com"

# REQUIRED GEMS
gem "grape", "~> 0.15.0"
gem "grape-entity"
gem "sequel"
gem "pg"
gem "rake"
gem "rack-cors"
gem "puma"
gem "dotenv"
gem "rest-client"
gem "rack-protection", git: "https://github.com/reevoo/rack-protection"
gem "rv-logstasher"
gem "grape_logging"
gem "sentry-raven"

# OPTIONAL GEMS, feel free to remove the gems below if you don't need them
gem "pony"
gem "elasticsearch"
gem "speakeasy", "2.3.2"
gem "aggregation_pipeline", "~> 1.2.0", require: false
gem "client_portal_api_client"
gem "jwt"
gem "whenever", require: false


group :development, :test do
  gem "racksh"
  gem "shotgun"
  gem "pry-byebug"
  gem "rspec"
  gem "rack-test"
  gem "simplecov"
  gem "letter_opener"
  gem "reevoocop"
end

group :deployment do
  gem "capistrano", "~> 3.4.0"
  gem "capistrano-bundler", "~> 1.1.4"
  gem "capistrano-rbenv", "~> 2.0"
end

group :test do
  gem "timecop"
  gem "capybara-angular", "0.1.0"
  gem "selenium-webdriver"
  gem "chromedriver-helper"
  gem "pact"
  gem "poltergeist"
  gem "bundler-audit", git: "https://github.com/rubysec/bundler-audit"
end

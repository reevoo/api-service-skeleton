require "rubygems"
require "bundler/setup"

Bundler.require(:default)

$LOAD_PATH << File.expand_path("../", __FILE__)

ENV["RACK_ENV"] ||= "development"
if %w(development test).include? ENV["RACK_ENV"]
  require "pry"
  require "dotenv"
  case ENV["RACK_ENV"]
  when "test"
    Dotenv.load ".env.test"
  when "development"
    Dotenv.load ".env"
  end
end

module FooService
  I18n.enforce_available_locales = true
  APP_NAME = "foo_service"

  def self.init
    Gyokuro.setup_es_instance(FooService::ES.instance)
    Gyokuro.setup_es_index(FooService::ES::INDEX)
    FooService::Mail.init
    CarmenClient.instance.host = ENV.fetch("CARMEN_HOST")
    Speakeasy.init
  end

  def self.logger
    @logger ||= begin
      if ENV["RACK_ENV"] == "development"
        Logger.new(STDOUT)
      else
        LogStasher.logger_for_app("myreevoo_fast_response_api", Rack::Directory.new("").root)
      end
    end
  end
end

ClientPortalApiClient.configure do |config|
  config.cp_api_token_secret = ENV.fetch("CP_API_TOKEN_SECRET")
  config.cp_api_url = ENV.fetch("CP_API_URL")
  config.cp_api_access_token = ENV.fetch("CP_API_ACCESS_TOKEN")
  config.app_name = FooService::APP_NAME
end

require "foo_service/speakeasy"
require "foo_service/db"
require "foo_service/es"
require "foo_service/mail"
require "foo_service/mailers/vetting_mailer" # TODO: MOVE THIS TO BETTER PLACE
require "foo_service/digest"
require "foo_service/raven"

FooService.init

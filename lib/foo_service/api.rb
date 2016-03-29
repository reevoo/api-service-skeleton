require "foo_service/errors"
require "foo_service/api/responses"
require "foo_service/api/search"
require "foo_service/api/saved_searches"
require "foo_service/api/metadata"
require "foo_service/api/autocomplete"
require "foo_service/api/misc"
require "foo_service/api/status"
require "foo_service/api/vetting"
require "foo_service/api/locks"
require "foo_service/api/alerts"

module FooService
  class API < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    logger FooService.logger
    use GrapeLogging::Middleware::RequestLogger, logger: FooService.logger

    rescue_from ClientPortalApiClient::Unauthorized do |err|
      API.logger.info(exception: err, tags: "rescued_exception", status: 401)
      error_response(message: "You are not authenticated", status: 401)
    end

    rescue_from ClientPortalApiClient::Forbidden, FooService::Forbidden do |err|
      API.logger.info(exception: err, tags: "rescued_exception", status: 403)
      error_response(message: "You are not allowed to perform this action", status: 403)
    end

    rescue_from FooService::NotFound do |err|
      API.logger.info(exception: err, tags: "rescued_exception", status: 404)
      error_response(message: "Not found", status: 404)
    end

    rescue_from Sequel::UniqueConstraintViolation do |err|
      case e.wrapped_exception
      when PG::UniqueViolation
        error_response(message: "Conflict", status: 409)
      end
      API.logger.error(err)
      throw err
    end

    rescue_from Grape::Exceptions::ValidationErrors do |err|
      API.logger.info(exception: err, tags: "rescued_exception")
      error_response(message: err.message, status: 400)
    end

    rescue_from :all do |err|
      API.logger.error(err)
      throw err
    end

    namespace do
      helpers do
        def current_user
          @current_user ||= ClientPortalApiClient::User.from_jwt(request.headers)
        end
      end

      before do
        current_user # Try to authenticate all calls
      end

      mount Responses
      mount Search
      mount SavedSearches
      mount Metadata
      mount Autocomplete
      mount Misc
      mount Status
      mount Locks
      mount Alerts
    end

    namespace :vetting do
      helpers do
        def current_user
          @current_user ||= ClientPortalApiClient::User.from_jwt(request.headers, "vetting")
        end
      end

      before do
        current_user # Try to authenticate all calls
      end

      mount Vetting
    end

  end
end

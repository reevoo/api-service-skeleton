require 'rack/cors'
require 'rack/static'
require 'rack/protection'
require 'logstasher/rack/common_logger_adapter'
require_relative 'lib/foo_service'
require 'foo_service/api'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :options, :post, :put, :delete]
  end
end

use Rack::CommonLogger, LogStasher::Rack::CommonLoggerAdapter.new(FooService.logger)
use Raven::Rack
use Rack::Protection, except: [ :remote_token, :session_hijacking, :http_origin]
use Rack::Protection::StrictTransport, include_subdomains: true
run FooService::API

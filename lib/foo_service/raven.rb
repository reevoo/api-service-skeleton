require "raven"

Raven.configure do |config|
  config.environments = %w(production staging)
  config.tags = { environment: ENV["RACK_ENV"] }
  config.silence_ready = false
end

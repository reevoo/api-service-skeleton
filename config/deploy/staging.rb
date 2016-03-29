server "staging14.reevoocloud.com", user: "conan", roles: %w(app db web whenever etl), primary: true

set :app_name, "foo_service-api"
set :default_env,
  "RACK_ENV" => "staging",
  "ES_URL" => "internal-elasticsearch-staging-1800332619.eu-west-1.elb.amazonaws.com:9200",
  "ES_INDEX" => "foo_service"

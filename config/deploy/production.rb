server "my1.reevoocloud.com", user: "conan", roles: %w(app db web), primary: true
server "my2.reevoocloud.com", user: "conan", roles: %w(app web)
server "my-aggpipe.reevoocloud.com", user: "conan", roles: %w(app whenever etl)

set :app_name, "foo_service-api"
set :default_env,
  "RACK_ENV" => "production",
  "ES_URL" => "internal-elasticsearch-1257253269.eu-west-1.elb.amazonaws.com:9200",
  "ES_INDEX" => "foo_service"

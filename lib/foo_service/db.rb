require "sequel"
require "yaml"

module FooService
  DB = Sequel.connect(ENV.fetch("DATABASE_URL"))
  Sequel::Model.plugin :timestamps
  DB.extension :pg_enum, :pg_array, :pg_json
end

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
  task default: [:spec]

rescue LoadError => e
  raise(e) if ENV["RACK_ENV"] == "test"
end

begin
  require "reevoocop/rake_task"
  ReevooCop::RakeTask.new(:reevoocop)
  task default: :reevoocop
rescue LoadError => e
  raise(e) if ENV["RACK_ENV"] == "test"
end

begin
  require "bundler/audit/task"
  Bundler::Audit::Task.new
  task default: "bundle:audit"
rescue LoadError => e
  raise(e) if ENV["RACK_ENV"] == "test"
end

Dir.glob("lib/tasks/*.rake").each { |r| load r }

task :env do
  require_relative "./lib/foo_service"
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] => [:env] do |_t, args|
    Sequel.extension :migration
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(FooService::DB, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(FooService::DB, "db/migrations")
    end
  end

  desc "reset to migration #0 (empty state)"
  task :reset do
    task("db:migrate").invoke(0)
    puts "DB reset"
  end

  desc "reset db and migrate to latest"
  task :remigrate do
    task("db:reset").invoke
    task("db:migrate").reenable
    task("db:migrate").invoke
  end
end

desc "API Routes"
task routes: [:env] do
  require "foo_service/api"
  FooService::API.routes.each do |route|
    method = route.route_method.ljust(10)
    path = route.route_path
    puts "     #{method} #{path}"
  end
end

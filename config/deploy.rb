lock "3.4.0"

set :application, "foo_service"
set :repo_url, "git@github.com:reevoo/#{fetch(:application)}.git"
set :repo_path, "/apps/#{fetch :application}-repo"
set :deploy_to, -> { "/apps/#{fetch :app_name}" }
set :rbenv_type, :system
set :rbenv_ruby, File.read(".ruby-version").strip
set :linked_files, %w(.env)
set :linked_dirs, %w(log)
set :whenever_roles, [:whenever, :etl]
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :branch, `git rev-parse HEAD`.chomp

namespace :deploy do
  desc "Run migrations"
  task :migrate do
    on primary(:db) do
      within release_path do
        execute :bundle, "exec dotenv rake db:migrate"
      end
    end
  end
  after "deploy:updated", "deploy:migrate"

  desc "Restart application"
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      execute "sudo /sbin/restart #{fetch :app_name}"
    end
  end
  after :publishing, :restart
end

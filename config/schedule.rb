# crob jobs definition, using https://github.com/javan/whenever

set :output, "/apps/foo_service/shared/log/cron.log"
set :environment_variable, "RACK_ENV"

job_type :dotenv_rake, "cd :path && :environment_variable=:environment bundle exec dotenv rake :task --silent :output"

every :day, at: "7pm", roles: [:whenever] do
  dotenv_rake "items:import"
end

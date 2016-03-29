set :output, "/apps/foo_service-api/shared/log/cron.log"
set :environment_variable, "RACK_ENV"

job_type :dotenv_rake, "cd :path && :environment_variable=:environment bundle exec dotenv rake :task --silent :output"

every :day, at: "7pm", roles: [:whenever] do
  dotenv_rake "digest:daily"
end

every :friday, at: "12pm", roles: [:whenever] do
  dotenv_rake "digest:weekly"
end

every "0 */6 * * *", roles: [:etl] do
  dotenv_rake "etl:product_reviews", output: "log/product_reviews_etl.log"
end

every "20 */6 * * *", roles: [:etl] do
  dotenv_rake "etl:customer_experience_reviews", output: "log/customer_experience_reviews_etl.log"
end

every "40 */6 * * *", roles: [:etl] do
  dotenv_rake "etl:conversation_questions", output: "log/conversation_questions_etl.log"
end

# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end
require 'sidekiq/api'
require_relative '../../app/sidekiq/background_task_job'

unless Sidekiq::Queue.new("default").find_job("BackgroundTaskJob")
  BackgroundTaskJob.perform_async
end

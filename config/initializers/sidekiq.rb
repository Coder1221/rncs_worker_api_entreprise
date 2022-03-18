def load_sidekiq_cron_jobs
  schedule_file = 'config/schedule.yml'

  if File.exists?(schedule_file)
    loaded_conf = YAML.load_file(schedule_file)
    # p '=================LOADED CRON JOBS============='
    Sidekiq::Cron::Job.load_from_hash(loaded_conf[Rails.env])
  end
end

sidekiq_config = { url: ENV['REDIS_URL'] }

# p '============================================================'
# sidekiq_config = { url: 'redis:6379/0' }
# sidekiq_config = { url: 'redis://redis:6379'}
# sidekiq_config = { url: 'localhost://redis:6379'}
# p sidekiq_config
# p  Rails.env
# p '============================================================'

# r = Redis.new(url: ENV['REDIS_URL'])

# REDIS_CONN= Redis::Namespace.new("sidekiq", redis: r)

Sidekiq.configure_server do |config|
  # config.redis = { url: Rails.configuration.redis_database }
  # config.redis = ConnectionPool.new(size: 4+2 , timeout: 1 , Redis::Namespace.new("sidekiq", redis: r)  )
  
  config.redis = sidekiq_config
  load_sidekiq_cron_jobs
end

Sidekiq.configure_client do |config|
  # config.redis = { url: Rails.configuration.redis_database }
  # config.redis = ConnectionPool.new(size: 4 , timeout: 1 , Redis::Namespace.new("sidekiq", redis: r))
  # config.server_middleware do |chain|
  #   chain.remove Sidekiq::Middleware::Server::RetryJobs
  # end
  
  config.redis = sidekiq_config
  load_sidekiq_cron_jobs
end

class RedisExpiryJob
  include Sidekiq::Job

  def perform(*args)
    Redis.increase_expiry_for_all_keys
  end
end

require 'redis'

class RedisHelper
  def initialize
    @redis = Redis.new
  end

  def add_to_list(key, value, expiration_seconds = 86400)  # Default to 24 hours (24 * 60 * 60 seconds)
    @redis.lpush(key, value)
    @redis.expire(key, expiration_seconds)
  end

  def read_list(key, start_index = 0, end_index = -1)
    @redis.lrange(key, start_index, end_index)
  end

  def remove_from_list(key, value, count = 0)
    @redis.lrem(key, count, value)
  end

  def del_list(key)
    @redis.del(key)
  end

  def key_exists?(key)
    @redis.exists(key)
  end

  def set_ttl(key, expiration_seconds)
    @redis.expire(key, expiration_seconds)
  end

  def get_ttl(key)
    @redis.ttl(key)
  end

  def increase_expiry_for_all_keys
    #We can fetch redis keys in batches if the keys are in millions
    all_keys = @redis.keys('*')
    all_keys.each do |key|
      current_ttl = @redis.ttl(key)
      if current_ttl >= 0
        new_ttl = current_ttl + 24 * 60 * 60
        @redis.expire(key, new_ttl)
      end
    end
  end

end

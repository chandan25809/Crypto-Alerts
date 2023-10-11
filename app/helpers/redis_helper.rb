require 'redis'
class RedisHelper
  def initialize
    @redis = Redis.new
  end

  def add_to_list(key,value)
    @redis.lpush(key, value)
  end

  def read_list(key, start_index = 0, end_index = -1)
    @redis.lrange(key, start_index, end_index)
  end

  def remove_from_list(key, value, count = 0)
    @redis.lrem(key, count, value)
  end

  def del_list(key)
    @redis.rem(key)
  end

end

require "redis"

module Kiwi
  class RedisStore < Store
    def initialize(@redis : Redis)
    end

    def set(key, val)
      @redis.set(key, val)
      val
    end

    def get(key)
      @redis.get(key)
    end

    def delete(key)
      val = get(key)
      @redis.del(key)
      val
    end

    def clear
      @redis.flushdb
      self
    end
  end
end

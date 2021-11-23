require "./store"
require "redis"

module Kiwi
  class RedisStore < Store
    def initialize(@redis : Redis)
    end

    def set(key, val) : String
      @redis.set(key, val)
      val
    end

    def get(key) : String | Nil
      @redis.get(key)
    end

    def delete(key) : String
      val = get(key)
      @redis.del(key)
      val || ""
    end

    def clear : Store
      @redis.flushdb
      self
    end
  end
end

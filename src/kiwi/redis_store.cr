require "./store"
require "redis"

module Kiwi
  class RedisStore < Store
    getter expires_in : Time::Span

    def initialize(@redis : Redis, @expires_in : Time::Span = 5.minutes)
    end

    def rset(key : String, val : String, expires : UInt32 = 0) : String
      @redis.set(key, val, expires)
      val
    end

    def set(key : String, val : String) : String
      rset(key, val, expires_in.to_i.to_u32)
    end

    def get(key : String) : String?
      @redis.get(key)
    end

    def delete(key : String) : String?
      get(key).tap do |_|
        @redis.del(key)
      end
    end

    def clear : Store
      @redis.flushdb
      self
    end
  end
end

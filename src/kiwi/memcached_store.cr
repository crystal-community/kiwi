require "./store"
require "memcached"

module Kiwi
  class MemcachedStore < Store
    getter expires_in : Time::Span

    def initialize(@memcached : Memcached::Client, @expires_in : Time::Span = 5.minutes)
    end

    def mset(key : String, val : String, expires_in : UInt32 = 0, version : Int64 = 0) : String
      @memcached.set(key, val, expires_in, version)
      val
    end

    def set(key : String, val : String) : String
      mset(key, val, expires_in.to_i.to_u32, 0.to_i64)
    end

    def get(key : String) : String?
      @memcached.get(key)
    end

    def delete(key : String) : String?
      get(key).tap do |_|
        @memcached.delete(key)
      end
    end

    def clear : Store
      @memcached.flush
      self
    end
  end
end

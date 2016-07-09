require "./store"
require "memcached"

module Kiwi
  class MemcachedStore < Store
    def initialize(@memcached : Memcached::Client)
    end

    def set(key, val)
      @memcached.set(key, val)
      val
    end

    def get(key)
      @memcached.get(key)
    end

    def delete(key)
      val = get(key)
      @memcached.delete(key)
      val
    end

    def clear
      @memcached.flush
      self
    end
  end
end

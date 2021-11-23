require "./store"
require "memcached"

module Kiwi
  class MemcachedStore < Store
    def initialize(@memcached : Memcached::Client)
    end

    def set(key, val) : String
      @memcached.set(key, val)
      val
    end

    def get(key) : String | Nil
      @memcached.get(key)
    end

    def delete(key) : String
      val = get(key)
      @memcached.delete(key)
      val || ""
    end

    def clear : Store
      @memcached.flush
      self
    end
  end
end

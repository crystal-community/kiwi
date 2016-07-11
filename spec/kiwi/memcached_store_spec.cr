require "../spec_helper"
require "../../src/kiwi/memcached_store"

describe Kiwi::MemcachedStore do
  behaves_like_store Kiwi::MemcachedStore.new(Memcached::Client.new)
end

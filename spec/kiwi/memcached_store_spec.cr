require "./../spec_helper"

describe Kiwi::MemcachedStore do
  behaves_like_store Kiwi::MemcachedStore.new(Memcached::Client.new)
end

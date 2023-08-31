require "./../spec_helper"
require "../../src/kiwi/redis_store"

describe Kiwi::RedisStore do
  behaves_like_store Kiwi::RedisStore.new(Redis.new(database: 13))
  behaves_like_expiring_store Kiwi::RedisStore.new(Redis.new(database: 13), 1.second)
end

require "./../spec_helper"

describe Kiwi::MemoryStore do
  behaves_like_store Kiwi::RedisStore.new(Redis.new(database: 13))
end

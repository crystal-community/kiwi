require "./../spec_helper"
require "../../src/kiwi/memory_store"

describe Kiwi::MemoryStore do
  behaves_like_store Kiwi::MemoryStore.new
end

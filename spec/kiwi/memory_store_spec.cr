require "./../spec_helper"

describe Kiwi::MemoryStore do
  behaves_like_store Kiwi::MemoryStore.new
end

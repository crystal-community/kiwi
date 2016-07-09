require "./../spec_helper"

describe Kiwi::MemoryStore do
  behaves_like_store Kiwi::FileStore.new(dir: "/tmp/kiwi_test")
end

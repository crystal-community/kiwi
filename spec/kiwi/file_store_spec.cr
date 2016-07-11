require "./../spec_helper"
require "../../src/kiwi/file_store"

describe Kiwi::FileStore do
  behaves_like_store Kiwi::FileStore.new(dir: "/tmp/kiwi_test")
end

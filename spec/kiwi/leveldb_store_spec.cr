require "./../spec_helper"

describe Kiwi::MemoryStore do
  behaves_like_store Kiwi::LevelDBStore.new(LevelDB::DB.new("/tmp/kiwi_leveldb_test"))
end

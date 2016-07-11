require "./../spec_helper"
require "../../src/kiwi/leveldb_store"

describe Kiwi::LevelDBStore do
  behaves_like_store Kiwi::LevelDBStore.new(LevelDB::DB.new("/tmp/kiwi_leveldb_test"))
end

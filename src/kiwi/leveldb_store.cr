require "./store"
require "leveldb"

module Kiwi
  class LevelDBStore < Store
    def initialize(@leveldb : ::LevelDB::DB)
    end

    def set(key, val)
      @leveldb.put(key, val)
      val
    end

    def get(key)
      @leveldb.get(key)
    end

    def delete(key)
      val = get(key)
      @leveldb.delete(key)
      val
    end

    def clear
      @leveldb.clear
      self
    end
  end
end

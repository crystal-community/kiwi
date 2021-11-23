require "./store"
require "leveldb"

module Kiwi
  class LevelDBStore < Store
    def initialize(@leveldb : ::LevelDB::DB)
    end

    def set(key, val) : String
      @leveldb.put(key, val)
      val
    end

    def get(key) : String | Nil
      @leveldb.get(key)
    end

    def delete(key) : String
      val = get(key)
      @leveldb.delete(key)
      val || ""
    end

    def clear : Store
      @leveldb.clear
      self
    end
  end
end

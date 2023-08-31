require "./store"
require "leveldb"

module Kiwi
  class LevelDBStore < Store
    def initialize(@leveldb : ::LevelDB::DB)
    end

    def set(key : String, val : String) : String
      @leveldb.put(key, val)
      val
    end

    def get(key : String) : String?
      @leveldb.get(key)
    end

    def delete(key : String) : String?
      get(key).tap do |val|
        @leveldb.delete(key) if val
      end
    end

    def clear : Store
      @leveldb.clear
      self
    end

    # exclusive LevelDB API
    def create_snapshot : LevelDB::Snapshot
      @leveldb.create_snapshot
    end

    def set_snapshot(snapshot : LevelDB::Snapshot)
      @leveldb.set_snapshot(snapshot)
    end

    def unset_snapshot
      @leveldb.unset_snapshot
    end
  end
end

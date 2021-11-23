require "./store"

module Kiwi
  class MemoryStore < Store
    def initialize
      @mem = Hash(String, String).new
    end

    def get(key) : String | Nil
      @mem[key]?
    end

    def set(key, val) : String
      @mem[key] = val
    end

    def delete(key) : String
      @mem.delete(key) || ""
    end

    def clear : Store
      @mem.clear
      self
    end
  end
end

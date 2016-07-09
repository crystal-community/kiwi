module Kiwi
  class MemoryStore < Store
    def initialize
      @mem = Hash(String, String).new
    end

    def get(key)
      @mem[key]?
    end

    #def has?(key)
    #  !!(@mem[key]?)
    #end

    def set(key, val)
      @mem[key] = val
    end

    def delete(key)
      @mem.delete(key)
    end

    def clear
      @mem.clear
      self
    end
  end
end

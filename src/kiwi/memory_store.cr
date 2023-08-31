require "./store"

module Kiwi
  class MemoryStore < Store
    getter expires_in : Time::Span

    def initialize(@expires_in : Time::Span = 5.minutes)
      @mem = Hash(String, TimedValue).new
    end

    def get(key : String) : String?
      memory = @mem[key]?
      return nil unless memory

      if memory[:expires_at] < Time.utc
        delete(key)
        nil
      else
        memory[:value]
      end
    end

    def set(key : String, val : String) : String
      memory = TimedValue.new(value: val, expires_at: Time.utc + expires_in)
      @mem[key] = memory
      val
    end

    def delete(key : String) : String?
      @mem.delete(key).try(&.[:value])
    end

    def clear : Store
      @mem.clear
      self
    end
  end
end

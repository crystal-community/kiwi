module Kiwi
  alias TimedValue = NamedTuple(value: String, expires_at: Time)

  abstract class Store
    abstract def get(key : String) : String | Nil
    abstract def set(key : String, val : String) : String
    abstract def delete(key : String) : String | Nil
    abstract def clear : Store

    def fetch(key : String, &) : String?
      get(key).tap do |value|
        if !value && (value = yield)
          set(key, value)
        end
      end
    end

    def []=(*args)
      set(*args)
    end

    def [](*args)
      get(*args)
    end
  end
end

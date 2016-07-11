module Kiwi
  abstract class Store
    abstract def get(key : String) : String|Nil
    abstract def set(key : String, val : String) : String
    abstract def delete(key : String) : String|Nil
    abstract def clear : Store

    def []=(*args)
      set(*args)
    end

    def [](*args)
      get(*args)
    end
  end
end

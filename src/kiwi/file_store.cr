require "digest/sha1"
require "file_utils"

module Kiwi
  class FileStore < Store
    def initialize(@dir : String)
      Dir.mkdir_p(@dir)
    end

    def get(key)
      file = file_for_key(key)
      File.exists?(file) ? File.read(file) : nil
    end

    def set(key, val)
      file = file_for_key(key)
      File.write(file, val)
      val
    end

    def delete(key)
      file = file_for_key(key)
      if File.exists?(file)
        value = File.read(file)
        File.delete(file)
        value
      else
        nil
      end
    end

    def clear
      FileUtils.rm_r(@dir)
      self
    end

    private def file_for_key(key)
      hex = Digest::SHA1.hexdigest(key)
      File.join(@dir, hex)
    end
  end
end

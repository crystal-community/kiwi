require "./store"
require "digest/sha1"
require "file_utils"

module Kiwi
  class FileStore < Store
    def initialize(@dir : String)
      @dir_created = false
      create_dir
    end

    def get(key : String) : String?
      file = file_for_key(key)
      File.exists?(file) ? File.read(file) : nil
    end

    def set(key : String, val : String) : String
      create_dir unless dir_created?

      file = file_for_key(key)
      File.write(file, val)
      val
    end

    def delete(key : String) : String?
      create_dir unless dir_created?

      file = file_for_key(key)
      return nil unless File.exists?(file)

      File.read(file).tap do |_|
        File.delete(file)
      end
    end

    def clear : Store
      remove_dir
      self
    end

    private def file_for_key(key : String)
      hex = Digest::SHA1.hexdigest(key)
      File.join(@dir, hex)
    end

    private def create_dir
      Dir.mkdir_p(@dir)
      @dir_created = true
    end

    private def remove_dir
      FileUtils.rm_r(@dir)
      @dir_created = false
    end

    private def dir_created?
      @dir_created
    end
  end
end

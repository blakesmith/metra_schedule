require 'fileutils'

module MetraSchedule
  class Cacher
    
    attr_accessor :cache_dir

    def initialize
      @cache_dir = "/home/#{ENV['USER']}/.metra_schedule"
    end

    def create_cache_dir_if_not_exists
      unless check_for_metra_cache_dir
        create_metra_cache_dir 
        true
      else
        false
      end
    end

    def check_for_metra_cache_dir
      File.exists?(@cache_dir) and File.directory?(@cache_dir)
    end

    def create_metra_cache_dir
      FileUtils.mkdir(@cache_dir)      
    end

  end
end

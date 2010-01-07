require 'fileutils'

module MetraSchedule
  class Cacher
    
    attr_accessor :cache_dir, :delays

    def initialize
      @cache_dir = "#{ENV['HOME']}/.metra_schedule"
      @delay_file = 'delays'
    end

    def self.load_from_cache(line)
      self.new.retrieve_line(line)
    end

    def self.store_to_cache(line)
      self.new.persist_line(line)
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

    def line_exists?(line)
      filename = line.line_key.to_s
      if File.exists?(File.join(@cache_dir, filename))
        true
      else
        false
      end
    end

    def delays_exist?
      return true if File.exists?(File.join(@cache_dir, @delay_file))
      false
    end

    def persist_line(line)
      create_cache_dir_if_not_exists
      return false unless line.engines
      true if File.open(File.join(@cache_dir, line.line_key.to_s), 'w') {|f| Marshal.dump(line.engines, f)}
    end

    def retrieve_line(line)
      if line_exists?(line)
        File.open(File.join(@cache_dir, line.line_key.to_s), 'r') {|f| Marshal.load(f)}
      else
        nil
      end
    end

    def persist_delays(delays)
      create_cache_dir_if_not_exists
      return false unless delays
      true if File.open(File.join(@cache_dir, @delay_file), 'w') {|f| Marshal.dump(delays, f)}
    end

    def retrieve_delays
      if delays_exist?
        File.open(File.join(@cache_dir, @delay_file), 'r') {|f| Marshal.load(f)}
      else
        nil
      end
    end
    
  end
end

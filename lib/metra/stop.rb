module MetraSchedule
  class Stop
    attr_reader :station, :time

    def initialize(options={})
      unless options.has_key?(:station) and options.has_key?(:time)
        raise ArgumentError.new "Stop objects must have a station and a time"
      end
      @station = options[:station] if options.has_key?(:station)
      @time = options[:time] if options.has_key?(:time)
    end

    def is_after?(time)
      @time > time
    end

    def self.pretty_print(sym)
      sym.to_s.split("_").map {|s| s.capitalize}.join("\s")
    end

    def to_hash
      {
        :stationName => @station,
        :timeHour => @time.hour,
        :timeMinute => @time.min
      }
    end

    def to_json
      to_hash.to_json
    end

  end
end

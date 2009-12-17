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
  end
end

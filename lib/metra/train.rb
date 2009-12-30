module MetraSchedule
  class Train
    attr_reader :train_num, :schedule, :bike_limit, :direction, :stops
    attr_accessor :my_departure, :my_arrival # Injected when the line is filtered

    def initialize(options={})
      unless options.empty?
        @train_num = options[:train_num] if options.has_key?(:train_num)
        @schedule = options[:schedule] if options.has_key?(:schedule)
        @bike_limit = options[:bike_limit] if options.has_key?(:bike_limit)
        @direction = options[:direction] if options.has_key?(:direction)
        @stops = options[:stops] if options.has_key?(:stops)
      end
    end

    def has_stop?(stop)
      return true if stops.any? {|s| s.station == stop}
      false
    end

    def in_time?(station, time)
      stop_time = stops.find {|s| s.station == station}.time
      return true if (stop_time.hour + stop_time.min) > (time.hour + time.min)
      false
    end

    def departure_and_arrival(start, destination)
      departure = @stops.find {|s| s.station == start}.time
      arrival = @stops.find {|s| s.station == destination}.time
      {:departure => departure, :arrival => arrival}
    end

  end
end

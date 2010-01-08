module MetraSchedule
  class Train
    attr_reader :train_num, :schedule, :bike_limit, :direction, :stops
    attr_accessor :my_departure, :my_arrival, :delay, :del_threshold # Injected when the line is filtered

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
      stop_time.to_today > time.to_today
    end

    def departure_and_arrival(start, destination)
      departure = @stops.find {|s| s.station == start}.time
      arrival = @stops.find {|s| s.station == destination}.time
      {:departure => departure.to_today, :arrival => arrival.to_today}
    end

    def departure_with_delay
      return @my_departure unless @del_threshold
      if @my_departure
        @my_departure + (60 * @del_threshold)
      end
    end

    def my_travel_time
      return nil unless @my_departure and @my_arrival
      minutes = (@my_arrival.to_i - @my_departure.to_i) / 60
      return minutes if minutes > 0
      return minutes + 1440 if minutes < 0
    end

    def print_my_travel_time
      if my_travel_time
        "#{print_my_travel_hours} #{print_my_travel_minutes}".strip
      end
    end

    def <=>(other)
      if my_departure
        return 1 if self.my_departure > other.my_departure
        return -1 if self.my_departure < other.my_departure
        return 0 if self.my_departure == other.my_departure
      elsif @stops.first and other.stops.first
        return 1 if @stops.first.time > other.stops.first.time
        return -1 if @stops.first.time < other.stops.first.time
        return 0 if @stops.first.time == other.stops.first.time
      else
        0
      end
    end

    private 

    def my_travel_hours
      (my_travel_time / 60.0).floor
    end

    def my_travel_minutes
      my_travel_time - (60 * my_travel_hours)
    end

    def print_my_travel_hours
      return nil if my_travel_hours == 0
      return "#{my_travel_hours} hour" if my_travel_hours == 1
      return "#{my_travel_hours} hours" if my_travel_hours > 1
    end

    def print_my_travel_minutes
      return nil if my_travel_minutes == 0
      return "#{my_travel_minutes} minute" if my_travel_minutes == 1
      return "#{my_travel_minutes} minutes" if my_travel_minutes > 1
    end

  end
end

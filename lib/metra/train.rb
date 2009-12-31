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
      if (stop_time.hour == time.hour)
        if (stop_time.min > time.min)
          return true
        else
          return false
        end
      elsif (stop_time.hour > time.hour)
        return true
      else
        return false
      end
    end

    def departure_and_arrival(start, destination)
      departure = @stops.find {|s| s.station == start}.time
      arrival = @stops.find {|s| s.station == destination}.time
      {:departure => departure, :arrival => arrival}
    end

    def my_travel_time
      return nil unless @my_departure and @my_arrival
      (@my_arrival.to_i - @my_departure.to_i) / 60
    end

    def print_my_travel_time
      if my_travel_time
        hours = (my_travel_time / 60.0).floor
        if hours > 0
          minutes = my_travel_time - (60 * hours)
          if hours == 1
            if minutes != 0
              return "#{hours} hour #{minutes} minutes"
            else
              return "#{hours} hour"
            end
          else
            if minutes != 0
              return "#{hours} hours #{minutes} minutes"
            else
              return "#{hours} hours"
            end
          end
        else
          minutes = my_travel_time
          return "#{minutes} minutes"
        end
      end
    end

  end
end

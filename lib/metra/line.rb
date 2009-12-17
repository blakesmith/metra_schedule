module MetraSchedule
  class Line
    attr_reader :name, :url, :dir, :sched, :start, :destination

    LINES = {
    :up_nw => {
      :name => "Union Pacific Northwest", 
      :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/up-nw/schedule.full.html',
      :stations => [
        :ogilve,
        :clyborn,
        :irving_park,
        :jefferson_park,
        :gladstone_park,
        :norwood_park,
        :edison_park,
        :park_ridge,
        :dee_road,
        :des_plaines,
        :cumberland,
        :mount_prospect,
        :arlington_heights,
        :arlington_park,
        :palatine,
        :barrington,
        :fox_river_grove,
        :cary,
        :pingree_road,
        :crystal_lake,
        :woodstock,
        :mchenry,
        :harvard
      ]
    }
  }

    def initialize(line_name)
      raise ArgumentError.new "That's not a valid line symbol. Please see the list in the README" \
        unless LINES.has_key?(line_name)
      raise ArgumentError.new "Please pass a symbol containing the line name" unless line_name.is_a?(Symbol)
      @name = LINES[line_name][:name]
      @url = LINES[line_name][:url]
    end
    
    def direction(dir=nil)
      raise ArgumentError.new "Direction must be either :inbound or :outbound" unless dir == :outbound || dir == :inbound || dir == nil
      @dir = dir unless dir == nil
      self
    end

    def outbound
      direction(:outbound)
    end

    def inbound
      direction(:inbound)
    end

    def schedule(sched=nil)
      unless sched == :weekday or sched == :saturday or sched == :sunday or sched == :holiday or sched == nil
        raise ArgumentError.new "Schedule must be :weekday, :saturday, :sunday or :holiday"
      end
      @sched = sched unless sched == nil
      self
    end

    def weekday
      schedule(:weekday)
    end

    def saturday
      schedule(:saturday)
    end

    def sunday
      schedule(:sunday)
    end

    def holiday
      schedule(:holiday)
    end

    def set_station(start_or_destination, station)
      unless start_or_destination == :start or start_or_destination == :destination
        raise ArgumentError.new "First argument must be either :start or :destination"
      end
      raise ArgumentError.new "Not a valid station" unless LINES[:up_nw][:stations].include?(station)
      @start = station if start_or_destination == :start
      @destination = station if start_or_destination == :destination 
      self
    end

  end
end

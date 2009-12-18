require File.join(File.dirname(__FILE__), 'train_data')

module MetraSchedule
  class Line
    include MetraSchedule::TrainData

    attr_reader :name, :url, :dir, :sched, :start, :destination, :time
    attr_accessor :engines

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

    def from(station)
      set_station(:start, station)
    end

    def to(station)
      set_station(:destination, station)
    end

    def at(time)
      begin
        @time = Time.parse(time)
      rescue
        raise ArgumentError.new "Time must be a valid time object" unless time.is_a?(Time)
      end
      self
    end

    def trains
      engines.find_all do |engine|
        filter_by_stop.include?(engine) and filter_by_start.include?(engine)
      end
    end

    private

    def filter_by_stop
      engines.find_all do |engine|
        engine.has_stop?(@start) and engine.has_stop?(@destination)
      end
    end

    def filter_by_start
      return engines if @time.nil? #No start time specified
      engines.find_all do |engine|
        engine.in_time?(@start, @time)
      end
    end

  end
end

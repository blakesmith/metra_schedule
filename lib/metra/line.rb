require File.join(File.dirname(__FILE__), 'train_data')

module MetraSchedule
  class Line
    include MetraSchedule::TrainData

    attr_reader :line_key, :name, :url, :dir, :sched, :start, :destination, :time
    attr_accessor :engines

    def initialize(line_name)
      raise ArgumentError.new "That's not a valid line symbol. Please see the list in the README" \
        unless LINES.has_key?(line_name)
      raise ArgumentError.new "Please pass a symbol containing the line name" unless line_name.is_a?(Symbol)
      @line_key = line_name
      @name = LINES[line_name][:name]
      @url = LINES[line_name][:url]
    end

    def load_schedule
      cached_line = MetraSchedule::Cacher.load_from_cache(self)
      unless cached_line
        update_schedule
      else
        @engines = cached_line.engines
      end
    end

    def update_schedule
      parser = MetraSchedule::Parser.new @url
      parser.line = LINES[@line_key]
      new_trains = parser.scrape
      if new_trains
        @engines = new_trains
        MetraSchedule::Cacher.store_to_cache(self)
        true
      else
        false
      end
    end
    
    def direction(dir=nil)
      raise ArgumentError.new "Direction must be either :inbound or :outbound" unless dir == :outbound || dir == :inbound || dir == nil
      @dir = dir unless dir == nil
      self
    end

    def deduce_direction
      return @dir if @dir
      return :unknown unless @start and @destination
      if LINES[@line_key][:stations].rindex(@start) < LINES[@line_key][:stations].rindex(@destination)
        :outbound
      elsif LINES[@line_key][:stations].rindex(@start) > LINES[@line_key][:stations].rindex(@destination)
        :inbound
      else
        :unknown
      end
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
      return [] unless engines
      engines.find_all do |engine|
        filter_by_stop.include?(engine) and \
          filter_by_start.include?(engine) and \
          filter_by_direction.include?(engine) and \
          filter_by_schedule.include?(engine)
      end
    end

    private

    def filter_by_stop
      if @start and not @destination
        engines.find_all { |e| e.has_stop?(@start) }
      elsif @destination and not @start
        engines.find_all { |e| e.has_stop?(@destination) }
      elsif @start and @destination
        engines.find_all { |e| e.has_stop?(@start) and e.has_stop?(@destination)}
      else
        engines
      end
    end

    def filter_by_start
      return engines if not @time or not @start
      engines.find_all do |engine|
        engine.in_time?(@start, @time)
      end
    end

    def filter_by_direction
      return engines if deduce_direction == :unknown
      engines.find_all do |engine|
        engine.direction == deduce_direction
      end
    end

    def filter_by_schedule
      return engines if not @sched
      engines.find_all do |engine|
        if @sched == :holiday or @sched == :sunday
          engine.schedule == :sunday or engine.schedule == :holiday
        else
          engine.schedule == @sched
        end
      end
    end

  end
end

module MetraSchedule
  class Line
    attr_reader :name, :url

    LINES = {
    :up_nw => {:name => "Union Pacific Northwest", :url => 'http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/up-nw/schedule.full.html'}
    }

    def initialize(line_name)
      raise ArgumentError "Please pass a symbol containing the line name" unless line_name.is_a?(Symbol)
      @name = LINES[line_name][:name]
      @url = LINES[line_name][:url]
    end
  end
end

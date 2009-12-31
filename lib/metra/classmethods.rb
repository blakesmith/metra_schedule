module MetraSchedule
  module InstanceMethods

    def line(line_name)
      MetraSchedule::Line.new(line_name)
    end

  end
end


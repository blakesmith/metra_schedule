module MetraSchedule
  module ClassMethods

    def line(line_name)
      MetraSchedule::Line.new(line_name)
    end

  end
end


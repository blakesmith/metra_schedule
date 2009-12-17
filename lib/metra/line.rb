module MetraSchedule
  class Line
    attr_reader :name, :url

    def initialize(args)
      @name = args[:name]
      @url = args[:url]
    end
  end
end

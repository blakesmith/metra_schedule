module MetraSchedule
  module Extensions
    module TimeExtension
      def to_today
        Time.local(Time.now.year, Time.now.month, Time.now.day, self.hour, self.min, self.sec)
      end
    end
  end
end

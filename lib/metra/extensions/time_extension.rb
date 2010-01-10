module MetraSchedule
  module Extensions
    module TimeExtension
      def to_today
        if self.hour >= 0 and self.hour <= 2 # Midnight to 2AM counts as the same day
          Time.local(Time.now.year, Time.now.month, Time.now.day+1, self.hour, self.min, self.sec)
        else
          Time.local(Time.now.year, Time.now.month, Time.now.day, self.hour, self.min, self.sec)
        end
      end
    end
  end
end

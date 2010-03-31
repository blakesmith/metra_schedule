module MetraSchedule
  module Extensions
    module TimeExtension
      def to_today
        if self.hour >= 0 and self.hour <= 2 # Midnight to 2AM counts as the same day
          if Time.now.month >= 12 and Time.now.day >= 31 #Dec 31st, can't overflow the months to 13
            year = Time.now.year + 1
            month = 1
            day = 1
          elsif Time.now.day >= 31 #Any 31st of the month, can't overflow days to 32
            year = Time.now.year
            month = Time.now.month + 1
            day = 1
          else #Otherwise just increment our day
            year = Time.now.year
            day = Time.now.day + 1
            month = Time.now.month
          end
          Time.local(year, month, day, self.hour, self.min, self.sec)
        else
          Time.local(Time.now.year, Time.now.month, Time.now.day, self.hour, self.min, self.sec)
        end
      end
    end
  end
end

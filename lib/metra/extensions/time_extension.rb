module MetraSchedule
  module Extensions
    module TimeExtension
      def to_today
        if self.hour >= 0 and self.hour <= 2 # Midnight to 2AM counts as the same day
          if Time.now.month >= 12 and Time.now.day >= 31 #Dec 31st, can't overflow the months to 13
            Time.local(Time.now.year+1, 1, 1, self.hour, self.min, self.sec)
          elsif Time.now.day >= 31 #Any 31st of the month, can't overflow days to 32
            Time.local(Time.now.year, Time.now.month+1, 1, self.hour, self.min, self.sec)
          else #Otherwise just increment our day
            Time.local(Time.now.year, Time.now.month, Time.now.day+1, self.hour, self.min, self.sec)
          end
        else
          Time.local(Time.now.year, Time.now.month, Time.now.day, self.hour, self.min, self.sec)
        end
      end
    end
  end
end

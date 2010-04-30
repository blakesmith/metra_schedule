module MetraSchedule
  module Extensions
    module TimeExtension
      def fast_forward(to_date=Time.now)
        if self.hour >= 0 and self.hour <= 2 # Midnight to 2AM counts as the same day
          if to_date.month >= 12 and to_date.day >= 31 #Dec 31st, can't overflow the months to 13
            Time.local(to_date.year+1, 1, 1, self.hour, self.min, self.sec)
          elsif to_date.day >= 31 #Any 31st of the month, can't overflow days to 32
            Time.local(to_date.year, to_date.month+1, 1, self.hour, self.min, self.sec)
          else #Otherwise just increment our day
            Time.local(to_date.year, to_date.month, to_date.day+1, self.hour, self.min, self.sec)
          end
        else
          Time.local(to_date.year, to_date.month, to_date.day, self.hour, self.min, self.sec)
        end
      end
    end
  end
end

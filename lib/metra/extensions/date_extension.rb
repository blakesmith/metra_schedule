module MetraSchedule
  module Extensions
    module DateExtension
      def to_time
        Time.local(self.year, self.month, self.day, 0, 0, 0)
      end
    end
  end
end

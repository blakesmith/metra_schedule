require File.join(File.dirname(__FILE__), 'metra', 'classmethods')
require File.join(File.dirname(__FILE__), 'metra', 'line')

class Metra
  include MetraSchedule::ClassMethods
end

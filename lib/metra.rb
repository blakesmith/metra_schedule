require File.join(File.dirname(__FILE__), 'metra', 'classmethods')
require File.join(File.dirname(__FILE__), 'metra', 'line')
require File.join(File.dirname(__FILE__), 'metra', 'train')
require File.join(File.dirname(__FILE__), 'metra', 'stop')

class Metra
  include MetraSchedule::ClassMethods
end

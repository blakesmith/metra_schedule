Bundler.setup

require File.join(File.dirname(__FILE__), 'metra', 'classmethods')
require File.join(File.dirname(__FILE__), 'metra', 'line')
require File.join(File.dirname(__FILE__), 'metra', 'train')
require File.join(File.dirname(__FILE__), 'metra', 'stop')
require File.join(File.dirname(__FILE__), 'metra', 'parser')
require File.join(File.dirname(__FILE__), 'metra', 'delay_parser')
require File.join(File.dirname(__FILE__), 'metra', 'cacher')
require File.join(File.dirname(__FILE__), 'metra', 'extensions', 'time_extension')

class Metra
  include MetraSchedule::InstanceMethods
end

Time.send(:include, MetraSchedule::Extensions::TimeExtension)

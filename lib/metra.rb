Bundler.setup

require 'date'
require 'time'
require File.join(File.dirname(__FILE__), 'metra', 'instancemethods')
require File.join(File.dirname(__FILE__), 'metra', 'line')
require File.join(File.dirname(__FILE__), 'metra', 'train')
require File.join(File.dirname(__FILE__), 'metra', 'stop')
require File.join(File.dirname(__FILE__), 'metra', 'parser')
require File.join(File.dirname(__FILE__), 'metra', 'delay_parser')
require File.join(File.dirname(__FILE__), 'metra', 'cacher')
require File.join(File.dirname(__FILE__), 'metra', 'extensions', 'time_extension')
require File.join(File.dirname(__FILE__), 'metra', 'extensions', 'date_extension')

class Metra
  include MetraSchedule::InstanceMethods
end

Time.send(:include, MetraSchedule::Extensions::TimeExtension)

# Fix for Ruby 1.8 - doesn't include 'to_time'
Date.send(:include, MetraSchedule::Extensions::DateExtension) unless Date.instance_methods.include?('to_time')

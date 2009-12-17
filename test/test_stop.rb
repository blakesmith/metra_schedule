require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def test_initialize_with_options
    time = Time.now
    assert_nothing_raised do
      @@s = MetraSchedule::Stop.new :station => :ogilve, :time => time
    end
    assert_equal(time, @@s.time)
    assert_equal(:ogilve, @@s.station)
  end

  def test_initialize_with_incomplete_options
    assert_raises ArgumentError do
      MetraSchedule::Stop.new :station => :ogilve
    end
    assert_raises ArgumentError do
      MetraSchedule::Stop.new :time => Time.now
    end
  end


end

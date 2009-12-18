require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def test_initialize_empty_options
    assert_nothing_raised do
      t = MetraSchedule::Train.new
    end
  end

  def test_initialize_one_option
    assert_nothing_raised do
      @@t = MetraSchedule::Train.new :train_num => 651
    end
    assert_equal(651, @@t.train_num)
  end

  def test_initialize_two_options
    assert_nothing_raised do
      @@t = MetraSchedule::Train.new :train_num => 651, :bikes => 12
    end
    assert_equal(651, @@t.train_num)
    assert_equal(12, @@t.bikes)
  end

  def test_initialize_all_options
    stop = MetraSchedule::Stop.new :station => :barrington, :time => Time.now
    assert_nothing_raised do
      @@t = MetraSchedule::Train.new :train_num => 651, :bikes => 12, :schedule => :weekday, :direction => :outbound, :stops => [stop]
    end
    assert_equal(651, @@t.train_num)
    assert_equal(12, @@t.bikes)
    assert_equal(:weekday, @@t.schedule)
    assert_equal(:outbound, @@t.direction)
    assert_equal([stop], @@t.stops)
  end

  def test_has_stop?
    stop = MetraSchedule::Stop.new :station => :barrington, :time => Time.now
    @@t = MetraSchedule::Train.new :train_num => 651, :bikes => 12, :schedule => :weekday, :direction => :outbound, :stops => [stop]
    assert(@@t.has_stop?(:barrington))
    assert(! @@t.has_stop?(:arlington_park))
  end

  def test_filter_by_time
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30")
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40")
    @@t = MetraSchedule::Train.new :train_num => 651, :bikes => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]
    @@t = @@t.filter_by_time(Time.parse("12:35"))
    assert(@@t.stops.any? {|s| s.station == :arlington_heights})
    assert(! @@t.stops.any? {|s| s.station == :barrington})
  end

end
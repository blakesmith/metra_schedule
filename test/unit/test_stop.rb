require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

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

  def test_is_after?
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30")
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40")
    assert(! stop1.is_after?(Time.parse("12:35")))
    assert(stop2.is_after?(Time.parse("12:35")))
  end

  def test_pretty_print
    assert_equal("Chicago Station", MetraSchedule::Stop.pretty_print(:chicago_station))
  end


end

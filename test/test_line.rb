require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def test_initialize_with_line_name
    assert_nothing_raised do
      Metra.new.line(:up_nw)
    end
    assert_raise ArgumentError do
      Metra.new.line("blah")
    end
  end

  def test_initialize_with_incorrect_line_symbol
    assert_raise ArgumentError do
      Metra.new.line(:blah)
    end
  end

  def test_has_name_and_url
    line = Metra.new.line(:up_nw)
    assert_equal("Union Pacific Northwest", line.name)
    assert_equal("http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/up-nw/schedule.full.html", line.url)
  end

  def test_direction
    line = Metra.new.line(:up_nw)
    assert_nothing_raised do
      line.direction :outbound
    end
    assert_equal(:outbound, line.dir)
    assert_nothing_raised do
      line.direction :inbound
    end
    assert_equal(:inbound, line.dir)
    assert_equal(line.direction.class, Metra.new.line(:up_nw).class)
  end

  def test_direction_incorrect_argument
    assert_raise ArgumentError do
      line = Metra.new.line(:up_nw).direction(:blah)
    end
  end

  def test_outbound
    line = Metra.new.line(:up_nw)
    assert_equal(line.direction(:outbound), line.outbound)
  end

  def test_inbound
    line = Metra.new.line(:up_nw)
    assert_equal(line.direction(:inbound), line.inbound)
  end

  def test_schedule
    line = Metra.new.line(:up_nw)
    assert_nothing_raised do
      line.schedule :weekday
    end
    assert_equal(:weekday, line.sched)
    assert_nothing_raised do
      line.schedule :saturday
    end
    assert_equal(:saturday, line.sched)
    assert_nothing_raised do
      line.schedule :sunday
    end
    assert_equal(:sunday, line.sched)
    assert_nothing_raised do
      line.schedule :holiday
    end
    assert_equal(:holiday, line.sched)
    assert_equal(line.schedule.class, Metra.new.line(:up_nw).class)
  end

  def test_weekday
    line = Metra.new.line(:up_nw)
    assert_equal(line.schedule(:weekday), line.weekday)
  end

  def test_saturday
    line = Metra.new.line(:up_nw)
    assert_equal(line.schedule(:saturday), line.saturday)
  end

  def test_sunday
    line = Metra.new.line(:up_nw)
    assert_equal(line.schedule(:sunday), line.sunday)
  end

  def test_holiday
    line = Metra.new.line(:up_nw)
    assert_equal(line.schedule(:holiday), line.holiday)
  end

  def test_set_station
    line = Metra.new.line(:up_nw)
    line.set_station(:start, :barrington)
    assert_equal(:barrington, line.start)
    line.set_station(:destination, :barrington)
    assert_equal(:barrington, line.destination)
  end

  def test_set_station_invalid_station
    line = Metra.new.line(:up_nw)
    assert_raises ArgumentError do
      line.set_station(:start, :bleepy_bleepy)
    end
  end

  def test_from
    line = Metra.new.line(:up_nw)
    assert_equal(line.set_station(:start, :barrington), line.from(:barrington))
  end

  def test_to
    line = Metra.new.line(:up_nw)
    assert_equal(line.set_station(:destination, :ogilve), line.to(:ogilve))
  end

  def test_trains_filter_by_station
    line = Metra.new.line(:up_nw)

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:30')
    stop3 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :stops => [stop1, stop2, stop3]
    train2 = MetraSchedule::Train.new :stops => [stop1, stop3]
    train3 = MetraSchedule::Train.new :stops => [stop2, stop3]
    line.engines = [train1, train2, train3]

    valid_trains = line.to(:barrington).from(:ogilve).trains
    assert_equal([train1, train2], valid_trains)
  end

end

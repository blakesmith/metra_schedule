require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestLine < Test::Unit::TestCase

  def test_initialize_empty_options
    assert_nothing_raised do
      t = MetraSchedule::Train.new
    end
  end

  def test_initialize_one_option
    assert_nothing_raised do
      @t = MetraSchedule::Train.new :train_num => 651
    end
    assert_equal(651, @t.train_num)
  end

  def test_initialize_two_options
    assert_nothing_raised do
      @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12
    end
    assert_equal(651, @t.train_num)
    assert_equal(12, @t.bike_limit)
  end

  def test_initialize_all_options
    stop = MetraSchedule::Stop.new :station => :barrington, :time => Time.now
    assert_nothing_raised do
      @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :outbound, :stops => [stop]
    end
    assert_equal(651, @t.train_num)
    assert_equal(12, @t.bike_limit)
    assert_equal(:weekday, @t.schedule)
    assert_equal(:outbound, @t.direction)
    assert_equal([stop], @t.stops)
  end

  def test_has_stop?
    stop = MetraSchedule::Stop.new :station => :barrington, :time => Time.now
    @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :outbound, :stops => [stop]
    assert_equal(true, @t.has_stop?(:barrington))
    assert_equal(false, @t.has_stop?(:arlington_park))
  end

  def test_in_time?
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30PM")
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40PM")
    @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]
    assert_equal(true, @t.in_time?(:arlington_heights, Time.parse("12:35PM")))
    assert_equal(false, @t.in_time?(:barrington, Time.parse("12:35PM")))
  end

  def test_in_time_midnight_inclusive
    stop1 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:30AM")
    stop2 = MetraSchedule::Stop.new :station => :cary, :time => Time.parse("2:45AM")
    stop3 = MetraSchedule::Stop.new :station => :harvard, :time => Time.parse("4:00AM")
    @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2, stop3]
    assert_equal(true, @t.in_time?(:arlington_heights, Time.parse("11:45PM")))
    assert_equal(true, @t.in_time?(:cary, Time.parse("11:45PM")))
    assert_equal(false, @t.in_time?(:harvard, Time.parse("11:45PM")))
  end

  def test_in_time_same_time_next_day
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30PM")
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40PM")
    @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]
    tomorrow = Time.parse("12:35PM") + (60 * 60 * 24)
    assert_equal(true, @t.in_time?(:arlington_heights, tomorrow))
    assert_equal(false, @t.in_time?(:barrington, tomorrow))
  end

  def test_departure_and_arrival
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30")
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40")
    @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]

    l = Metra.new.line(:up_nw)
    l.engines = [@t]
    train = l.trains.first
    assert_equal({:departure => Time.parse("12:30"), :arrival => Time.parse("12:40")}, train.departure_and_arrival(:barrington, :arlington_heights))
  end

  def test_departure_and_arrival_for_tomorrow
    Timecop.freeze(2010, 4, 29) do
      stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30PM")
      stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40PM")
      @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]

      l = Metra.new.line(:up_nw)
      l.engines = [@t]
      l.on(Date.today + 1)
      train = l.trains.first
      assert_not_nil train
      expected = {:departure => Time.parse("april 30th 2010 12:30PM"), :arrival => Time.parse("april 30th 2010 12:40PM")}
      assert_equal(expected, train.departure_and_arrival(:barrington, :arlington_heights))
    end
  end

  def test_my_departure_and_my_arrival
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30")
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40")
    @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]

    l = Metra.new.line(:up_nw).from(:barrington).to(:arlington_heights)
    l.engines = [@t]
    train = l.trains.first
    assert_equal(Time.parse("12:30"), train.my_departure)
    assert_equal(Time.parse("12:40"), train.my_arrival)
  end

  def test_my_departure_and_my_arrival_with_cached_from_another_day
    Timecop.freeze(2010, 1, 5) do
      stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30")
      stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40")
      @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]
    end

    Timecop.freeze(2010, 1, 6) do
      l = Metra.new.line(:up_nw).from(:barrington).to(:arlington_heights)
      l.engines = [@t]
      train = l.trains.first
      assert_equal(Time.parse("12:30"), train.my_departure)
      assert_equal(Time.parse("12:40"), train.my_arrival)
    end
  end

  def test_my_departure_and_my_arrival_with_no_start_or_destination
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30")
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40")
    @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]

    l = Metra.new.line(:up_nw)
    l.engines = [@t]
    train = l.trains.first
    assert_equal(nil, train.my_departure)
    assert_equal(nil, train.my_arrival)
  end

  def test_my_travel_time
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    train.my_departure = Time.parse("12:30PM")
    train.my_arrival = Time.parse("1:30PM")
    assert_equal(60, train.my_travel_time)
  end

  def test_my_travel_time_nil
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    assert_equal(nil, train.my_travel_time)
  end

  def test_my_travel_time_one_day_into_next
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    train.my_departure = Time.parse("11:30PM")
    train.my_arrival = Time.parse("12:30AM")
    assert_equal(60, train.my_travel_time)

    train.my_arrival = Time.parse("1:30AM")
    assert_equal(120, train.my_travel_time)
  end

  def test_print_my_travel_time_minutes
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    train.my_departure = Time.parse("12:30PM")
    train.my_arrival = Time.parse("1:29PM")
    assert_equal("59 minutes", train.print_my_travel_time)
  end

  def test_print_my_travel_time_one_hour
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    train.my_departure = Time.parse("12:30PM")
    train.my_arrival = Time.parse("1:30PM")
    assert_equal("1 hour", train.print_my_travel_time)
  end

  def test_print_my_travel_time_one_hour_and_minutes
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    train.my_departure = Time.parse("12:30PM")
    train.my_arrival = Time.parse("1:35PM")
    assert_equal("1 hour 5 minutes", train.print_my_travel_time)
  end

  def test_print_my_travel_time_two_hours
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    train.my_departure = Time.parse("12:30PM")
    train.my_arrival = Time.parse("2:30PM")
    assert_equal("2 hours", train.print_my_travel_time)
  end

  def test_print_my_travel_time_two_hours_and_minutes
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    train.my_departure = Time.parse("12:30PM")
    train.my_arrival = Time.parse("2:35PM")
    assert_equal("2 hours 5 minutes", train.print_my_travel_time)
  end

  def test_departure_with_delay
    train = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound
    train.my_departure = Time.parse("12:30PM")
    train.del_threshold = 5
    assert_equal(Time.parse("12:35PM"), train.departure_with_delay)
  end

  def test_to_json
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse("12:30PM")
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse("12:40PM")
    @t = MetraSchedule::Train.new :train_num => 651, :bike_limit => 12, :schedule => :weekday, :direction => :inbound, :stops => [stop1, stop2]

    subject = JSON.parse(@t.to_json)
    assert_equal 651, subject['trainNumber']
    assert_equal "weekday", subject['schedule']
    assert_equal "inbound", subject['direction']
    stop1 = subject['stops'].first
    assert_equal "Barrington", stop1['stationName']
    assert_equal 12, stop1['timeHour']
    assert_equal 30, stop1['timeMinute']
    stop2 = subject['stops'].last
    assert_equal "Arlington Heights", stop2['stationName']
    assert_equal 12, stop2['timeHour']
    assert_equal 40, stop2['timeMinute']
  end

end

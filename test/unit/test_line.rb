require File.join(File.dirname(__FILE__), "../", "test_helper.rb")
begin
  require 'mocha'
rescue
  puts "Not all the tests may function properly without Mocha installed. gem install mocha"
end

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

  def test_cache_params
    line = Metra.new.line(:up_nw)
    line.config :cacher => :tokyo, :cache_dir => '/home/blake/.metra_scheudule'
    assert_equal(:tokyo, line.cacher)
    assert_equal('/home/blake/.metra_scheudule', line.cache_dir)
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
    assert_equal(line.direction(:inbound).class, Metra.new.line(:up_nw).class)
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
    assert_equal(line.schedule(:holiday).class, Metra.new.line(:up_nw).class)
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

  def test_at
    line = Metra.new.line(:up_nw)
    test_time = "12:30PM"
    assert_nothing_raised do
      line.at(Time.now)
      line.at(test_time)
    end
    assert_equal(line.time, Time.parse(test_time))
    line.at(Time.parse("12:30PM"))
    assert_raises ArgumentError do
      line.at(:bloopybloop)
    end
  end

  def test_deduce_direction
    line = Metra.new.line(:up_nw)

    assert_equal(:outbound, line.from(:ogilve).to(:barrington).deduce_direction)
    assert_equal(:inbound, line.from(:barrington).to(:ogilve).deduce_direction)
  end

  def test_trains_sorted_by_departure_time
    line = Metra.new.line(:up_nw)

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:40')
    stop3 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :stops => [stop1, stop3], :direction => :outbound, :schedule => :weekday
    train2 = MetraSchedule::Train.new :stops => [stop2, stop3], :direction => :outbound, :schedule => :weekday
    line.engines = [train2, train1]

    valid_trains = line.outbound.trains
    assert_equal([train1, train2], valid_trains)
  end

  def test_trains_filter_by_station
    line = Metra.new.line(:up_nw)

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:30')
    stop3 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :stops => [stop1, stop2, stop3], :direction => :outbound, :schedule => :weekday
    train2 = MetraSchedule::Train.new :stops => [stop1, stop3], :direction => :outbound, :schedule => :weekday
    train3 = MetraSchedule::Train.new :stops => [stop2, stop3], :direction => :outbound, :schedule => :weekday
    line.engines = [train1, train2, train3]

    valid_trains = line.to(:barrington).from(:ogilve).trains
    assert_equal([train1, train2], valid_trains)
  end

  def test_trains_filter_by_start
    line = Metra.new.line(:up_nw)

    stop1 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:40')
    stop3 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :stops => [stop1, stop3], :direction => :inbound, :schedule => :weekday
    train2 = MetraSchedule::Train.new :stops => [stop2, stop3], :direction => :inbound, :schedule => :weekday
    line.engines = [train1, train2]

    valid_trains = line.to(:ogilve).from(:arlington_heights).at('12:35').trains
    assert_equal([train2], valid_trains)
  end

  def test_trains_filter_by_start_with_delay_threshold
    line = Metra.new.line(:up_nw).delay_threshold(10)

    stop1 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:40')
    stop3 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :stops => [stop1, stop3], :direction => :inbound, :schedule => :weekday
    train2 = MetraSchedule::Train.new :stops => [stop2, stop3], :direction => :inbound, :schedule => :weekday
    train1.delay = "Delayed"
    line.engines = [train1, train2]

    valid_trains = line.to(:ogilve).from(:arlington_heights).at('12:35').trains
    assert_equal([train1, train2], valid_trains)
  end

  def test_trains_just_direction_and_time
    line = Metra.new.line(:up_nw)

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:30')
    stop3 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :stops => [stop1, stop2, stop3], :direction => :outbound, :schedule => :weekday
    train2 = MetraSchedule::Train.new :stops => [stop1, stop3], :direction => :outbound, :schedule => :weekday
    train3 = MetraSchedule::Train.new :stops => [stop2, stop3], :direction => :outbound, :schedule => :weekday
    line.engines = [train1, train2, train3]

    valid_trains = line.outbound.at('12:00').trains
    assert_equal([train1, train2, train3], valid_trains)
  end

  def test_filter_by_direction
    line = Metra.new.line(:up_nw)

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')

    train1 = MetraSchedule::Train.new :direction => :outbound, :stops => [stop1, stop2], :schedule => :weekday
    train2 = MetraSchedule::Train.new :direction => :inbound, :stops => [stop1, stop2], :schedule => :weekday
    train3 = MetraSchedule::Train.new :direction => :outbound, :stops => [stop1, stop2], :schedule => :weekday
    line.engines = [train1, train2, train3]

    valid_trains = line.to(:barrington).from(:ogilve).trains
    assert_equal([train1, train3], valid_trains)
  end

  def test_filter_by_schedule
    line = Metra.new.line(:up_nw)

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')

    train1 = MetraSchedule::Train.new :direction => :outbound, :stops => [stop1, stop2], :schedule => :weekday
    train2 = MetraSchedule::Train.new :direction => :outbound, :stops => [stop1, stop2], :schedule => :holiday
    train3 = MetraSchedule::Train.new :direction => :outbound, :stops => [stop1, stop2], :schedule => :saturday
    train4 = MetraSchedule::Train.new :direction => :outbound, :stops => [stop1, stop2], :schedule => :sunday
    line.engines = [train1, train2, train3, train4]

    valid_weekday = line.to(:barrington).from(:ogilve).weekday.trains
    assert_equal([train1], valid_weekday)
    valid_saturday = line.to(:barrington).from(:ogilve).saturday.trains
    assert_equal([train3], valid_saturday)
    valid_holiday = line.to(:barrington).from(:ogilve).holiday.trains
    assert_equal([train2, train4], valid_holiday)
    valid_sunday = line.to(:barrington).from(:ogilve).sunday.trains
    assert_equal([train2, train4], valid_sunday)
  end

  def test_no_engines
    line = Metra.new.line(:up_nw)

    assert_nothing_raised do
      line.outbound.trains
    end
  end

  def test_all_trains_on_line
    line = Metra.new.line(:up_nw)

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')

    train1 = MetraSchedule::Train.new :direction => :inbound, :stops => [stop1, stop2], :schedule => :weekday
    train2 = MetraSchedule::Train.new :direction => :outbound, :stops => [stop1, stop2], :schedule => :holiday
    train3 = MetraSchedule::Train.new :direction => :inbound, :stops => [stop1, stop2], :schedule => :saturday
    train4 = MetraSchedule::Train.new :direction => :outbound, :stops => [stop1, stop2], :schedule => :sunday
    line.engines = [train1, train2, train3, train4]

    assert_equal([train1, train2, train3, train4], line.trains)
  end

  def test_on
    line = Metra.new.line(:up_nw)
    assert_equal(:weekday, line.on(Date.civil(2009, 12, 29)).sched)
    assert_equal(:saturday, line.on(Date.civil(2009, 12, 26)).sched)
    assert_equal(:sunday, line.on(Date.civil(2009, 12, 27)).sched)

    assert_raises ArgumentError do
      line.on("blah")
    end
  end

  def test_on_holiday_fixed_date_holidays
    line = Metra.new.line(:up_nw)
    assert_equal(:holiday, line.on(Date.parse('january 1st')).sched)
    assert_equal(:holiday, line.on(Date.parse('july 4th')).sched)
    assert_equal(:holiday, line.on(Date.parse('december 25th')).sched)
  end

  def test_on_holiday_moving_date_holidays
    line = Metra.new.line(:up_nw)
    assert_equal(:holiday, line.on(Date.parse('may 31st 2010')).sched) #Memorial Day
    assert_equal(:holiday, line.on(Date.parse('may 25th 2009')).sched)
    assert_equal(:holiday, line.on(Date.parse('september 6th 2010')).sched) #Labor Day
    assert_equal(:holiday, line.on(Date.parse('september 7th 2009')).sched)
    assert_equal(:holiday, line.on(Date.parse('november 25th 2010')).sched) #Thanksgiving
    assert_equal(:holiday, line.on(Date.parse('november 26th 2009')).sched) #Thanksgiving
  end

  def test_on_effective_date
    line = Metra.new.line(:up_nw)
    date = Date.parse("dec 31st 2009")
    line.on(date)
    assert_equal(date, line.effective_date)
  end

  def test_on_with_effective_date_injection
    line = Metra.new.line(:up_nw)
    date = Date.parse("dec 17th 2009")

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    train1 = MetraSchedule::Train.new :train_num => 642, :direction => :inbound, :stops => [stop1], :schedule => :weekday
    line.engines = [train1]
    line.on(date)

    assert_equal(1, line.trains.count)
    assert_equal(date, line.trains.first.effective_date)
  end

  def test_deduce_schedule
    line = Metra.new.line(:up_nw)
    Timecop.freeze(2009, 12, 27) do
      assert_equal(:sunday, line.deduce_schedule.sched)
    end
  end

  def test_find_train_by_train_num
    line = Metra.new.line(:up_nw)
    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :train_num => 642, :direction => :inbound, :stops => [stop1, stop2], :schedule => :weekday
    train2 = MetraSchedule::Train.new :train_num => 631, :direction => :outbound, :stops => [stop1, stop2], :schedule => :holiday
    line.engines = [train1, train2]

    assert_equal(train1, line.find_train_by_train_num(642))
  end

  def test_delay_threshold
    line = Metra.new.line(:up_nw)
    line.delay_threshold(5)
    assert_equal(5, line.del_threshold)
  end

end

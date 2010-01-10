require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestLine < Test::Unit::TestCase
  include MetraSchedule::TrainData

  def p
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/UP_NW.html'), 'r')
    parser = MetraSchedule::Parser.new f
    parser.line = LINES[:up_nw]
    parser.scrape
    parser
  end

  def up_nw_stub
    p
  end

  def test_init
    assert_nothing_raised do
      @@p = MetraSchedule::Parser.new 'http://blake.com'
    end
    assert_not_nil(up_nw_stub.html_doc)
    assert_not_nil(@@p.html_doc)
  end

  def test_seperate_tables
    assert_equal(2, p.tables.find_all {|t| t[:schedule] == :weekday}.count)
    assert_equal(2, p.tables.find_all {|t| t[:schedule] == :saturday}.count)
    assert_equal(2, p.tables.find_all {|t| t[:schedule] == :sunday}.count)
  end

  def test_sanitize
    list = [1, 2, 3]
    assert_equal(2, p.sanitize(list).count)
  end

  def test_train_count
    assert_equal(16, p.train_count(p.tables[0][:tables][0]))
    assert_equal(16, p.train_count(p.tables[0][:tables][1]))
    assert_equal(12, p.train_count(p.tables[1][:tables][0]))
    assert_equal(7, p.train_count(p.tables[2][:tables][0]))
    assert_equal(16, p.train_count(p.tables[3][:tables][0]))
    assert_equal(16, p.train_count(p.tables[3][:tables][1]))
    assert_equal(1, p.train_count(p.tables[3][:tables][2]))
    assert_equal(12, p.train_count(p.tables[4][:tables][0]))
  end

  def test_stop_count
    assert_equal(23, p.stop_count(p.tables[0][:tables][0]))
  end

  def test_make_stop_inbound
    node = p.tables[0][:tables][0].xpath("tbody[4]/tr/td[1]")[0]
    expected = MetraSchedule::Stop.new :station => :crystal_lake, :time => Time.parse("4:47AM")
    assert_equal(expected.station, p.make_stop(node, 3, :inbound).station)
    assert_equal(expected.time, p.make_stop(node, 3, :inbound).time)
  end

  def test_make_stop_outbound
    node = p.tables[3][:tables][0].xpath("tbody[4]/tr/td[1]")[0]
    expected = MetraSchedule::Stop.new :station => :jefferson_park, :time => Time.parse("6:13AM")
    assert_equal(expected.station, p.make_stop(node, 3, :outbound).station)
    assert_equal(expected.time, p.make_stop(node, 3, :outbound).time)
  end

  def test_make_stop_nil
    node = p.tables[0][:tables][0].xpath("tbody[1]/tr/td[1]")[0]
    assert_nil(p.make_stop(node, 0, :inbound))
  end

  def test_make_stop_am
    node = p.tables[0][:tables][1].xpath("tbody[18]/tr/td[5]")[0]
    expected = MetraSchedule::Stop.new :station => :norwood_park, :time => Time.parse("11:57AM")
    assert_equal(expected.station, p.make_stop(node, 17, :inbound).station)
    assert_equal(expected.time, p.make_stop(node, 17, :inbound).time)
  end

  def test_make_stop_pm
    node = p.tables[0][:tables][1].xpath("tbody[20]/tr/td[5]")[0]
    expected = MetraSchedule::Stop.new :station => :jefferson_park, :time => Time.parse("12:01PM")
    assert_equal(expected.station, p.make_stop(node, 19, :inbound).station)
    assert_equal(expected.time, p.make_stop(node, 19, :inbound).time)
  end

  def test_make_stop_pm_express
    node = p.tables[3][:tables][1].xpath("tbody[2]/tr/td[5]")[0]
    expected = MetraSchedule::Stop.new :station => :clyborn, :time => Time.parse("5:29PM")
    assert_equal(expected.station, p.make_stop(node, 1, :outbound).station)
    assert_equal(expected.time, p.make_stop(node, 1, :outbound).time)
  end

  def test_find_stops
    table = p.tables[0][:tables][0]
    assert_equal(19, p.find_stops(table, 1, :inbound).count)
  end

  def test_find_stops_express
    table = p.tables[0][:tables][0]
    stops = p.find_stops(table, 5, :inbound)
    assert_equal(Time.parse("6:43AM").to_f , stops[6].time.to_f)
    assert_equal(:arlington_park, stops[6].station)
    assert_equal(10, stops.count)
  end

  def test_make_trains_count
    trains = p.make_trains
    assert_equal(104, p.make_trains.count)
  end

  def test_find_train_num
    train_602 = p.make_trains.first
    train_632 = p.make_trains[15]

    assert_equal(602, train_602.train_num)
    assert_equal(632, train_632.train_num)
  end

  def test_find_bike_count
    train_602 = p.make_trains.first
    train_640 = p.make_trains[18]

    assert_equal(nil, train_602.bike_limit)
    assert_equal(12, train_640.bike_limit)
  end

end

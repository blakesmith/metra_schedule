require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestLine < Test::Unit::TestCase
  include MetraSchedule::TrainData

  def up_nw_stub
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/UP_NW.html'), 'r')
    parser = MetraSchedule::Parser.new f
    parser.line = LINES[:up_nw]
    parser.scrape
    parser
  end

  def test_init
    assert_nothing_raised do
      @p = MetraSchedule::Parser.new 'http://blake.com'
    end
    assert_not_nil(up_nw_stub.html_doc)
    assert_not_nil(@p.html_doc)
  end

  def test_seperate_tables
    assert_equal(2, up_nw_stub.tables.find_all {|t| t[:schedule] == :weekday}.count)
    assert_equal(2, up_nw_stub.tables.find_all {|t| t[:schedule] == :saturday}.count)
    assert_equal(2, up_nw_stub.tables.find_all {|t| t[:schedule] == :sunday}.count)
  end

  def test_sanitize
    list = [1, 2, 3]
    assert_equal(2, up_nw_stub.sanitize(list).count)
  end

  def test_train_count
    assert_equal(16, up_nw_stub.train_count(up_nw_stub.tables[0][:tables][0]))
    assert_equal(16, up_nw_stub.train_count(up_nw_stub.tables[0][:tables][1]))
    assert_equal(12, up_nw_stub.train_count(up_nw_stub.tables[1][:tables][0]))
    assert_equal(7, up_nw_stub.train_count(up_nw_stub.tables[2][:tables][0]))
    assert_equal(16, up_nw_stub.train_count(up_nw_stub.tables[3][:tables][0]))
    assert_equal(16, up_nw_stub.train_count(up_nw_stub.tables[3][:tables][1]))
    assert_equal(1, up_nw_stub.train_count(up_nw_stub.tables[3][:tables][2]))
    assert_equal(12, up_nw_stub.train_count(up_nw_stub.tables[4][:tables][0]))
  end

  def test_stop_count
    assert_equal(23, up_nw_stub.stop_count(up_nw_stub.tables[0][:tables][0]))
  end

  def test_make_stop_inbound
    node = up_nw_stub.tables[0][:tables][0].xpath("tbody[4]/tr/td[1]")[0]
    expected = MetraSchedule::Stop.new :station => :crystal_lake, :time => Time.parse("4:47AM")
    assert_equal(expected.station, up_nw_stub.make_stop(node, 3, :inbound).station)
    assert_equal(expected.time, up_nw_stub.make_stop(node, 3, :inbound).time)
  end

  def test_make_stop_outbound
    node = up_nw_stub.tables[3][:tables][0].xpath("tbody[4]/tr/td[1]")[0]
    expected = MetraSchedule::Stop.new :station => :jefferson_park, :time => Time.parse("6:13AM")
    assert_equal(expected.station, up_nw_stub.make_stop(node, 3, :outbound).station)
    assert_equal(expected.time, up_nw_stub.make_stop(node, 3, :outbound).time)
  end

  def test_make_stop_nil
    node = up_nw_stub.tables[0][:tables][0].xpath("tbody[1]/tr/td[1]")[0]
    assert_nil(up_nw_stub.make_stop(node, 0, :inbound))
  end

  def test_make_stop_am
    node = up_nw_stub.tables[0][:tables][1].xpath("tbody[18]/tr/td[5]")[0]
    expected = MetraSchedule::Stop.new :station => :norwood_park, :time => Time.parse("11:57AM")
    assert_equal(expected.station, up_nw_stub.make_stop(node, 17, :inbound).station)
    assert_equal(expected.time, up_nw_stub.make_stop(node, 17, :inbound).time)
  end

  def test_make_stop_pm
    node = up_nw_stub.tables[0][:tables][1].xpath("tbody[20]/tr/td[5]")[0]
    expected = MetraSchedule::Stop.new :station => :jefferson_park, :time => Time.parse("12:01PM")
    assert_equal(expected.station, up_nw_stub.make_stop(node, 19, :inbound).station)
    assert_equal(expected.time, up_nw_stub.make_stop(node, 19, :inbound).time)
  end

  def test_make_stop_pm_express
    node = up_nw_stub.tables[3][:tables][1].xpath("tbody[2]/tr/td[5]")[0]
    expected = MetraSchedule::Stop.new :station => :clyborn, :time => Time.parse("5:29PM")
    assert_equal(expected.station, up_nw_stub.make_stop(node, 1, :outbound).station)
    assert_equal(expected.time, up_nw_stub.make_stop(node, 1, :outbound).time)
  end

  def test_find_stops
    table = up_nw_stub.tables[0][:tables][0]
    assert_equal(19, up_nw_stub.find_stops(table, 1, :inbound).count)
  end

  def test_find_stops_express
    table = up_nw_stub.tables[0][:tables][0]
    stops = up_nw_stub.find_stops(table, 5, :inbound)
    assert_equal(Time.parse("6:43AM").to_f , stops[6].time.to_f)
    assert_equal(:arlington_park, stops[6].station)
    assert_equal(10, stops.count)
  end

  def test_make_trains_count
    trains = up_nw_stub.make_trains
    assert_equal(104, up_nw_stub.make_trains.count)
  end

  def test_find_train_num
    train_602 = up_nw_stub.make_trains.first
    train_632 = up_nw_stub.make_trains[15]

    assert_equal(602, train_602.train_num)
    assert_equal(632, train_632.train_num)
  end

  def test_find_bike_count
    train_602 = up_nw_stub.make_trains.first
    train_640 = up_nw_stub.make_trains[18]

    assert_equal(nil, train_602.bike_limit)
    assert_equal(12, train_640.bike_limit)
  end

  def test_find_table
    expected = up_nw_stub.tables[3][:tables][1]
    actual = up_nw_stub.find_table(:schedule => :weekday, :direction => :outbound, :table => 2)
    assert_equal(expected.text, actual.text)
  end

  def test_find_node
    table = up_nw_stub.find_table(:schedule => :weekday, :direction => :outbound, :table => 2)
    expected = up_nw_stub.tables[3][:tables][1].xpath("tbody[2]/tr/td[5]").first
    actual = up_nw_stub.find_node(table, :row => 2, :column => 5)
    assert_equal(expected.text, actual.text)
  end

end

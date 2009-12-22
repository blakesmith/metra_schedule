require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase
  include MetraSchedule::TrainData

  def up_nw_stub
    f = File.open(File.join(File.dirname(__FILE__), 'fixture/UP_NW.html'), 'r')
    parser = MetraSchedule::Parser.new f
    parser.line = LINES[:up_nw]
    parser.scrape
    parser
  end

  def test_init
    assert_nothing_raised do
      @@p = MetraSchedule::Parser.new 'http://blake.com'
    end
    assert_not_nil(up_nw_stub.html_doc)
    assert_not_nil(@@p.html_doc)
  end

  def test_seperate_tables
    p = up_nw_stub
    assert_equal(2, p.tables.find_all {|t| t[:schedule] == :weekday}.count)
    assert_equal(2, p.tables.find_all {|t| t[:schedule] == :saturday}.count)
    assert_equal(2, p.tables.find_all {|t| t[:schedule] == :sunday}.count)
  end

  def test_sanitize
    p = up_nw_stub
    list = [1, 2, 3]
    assert_equal(2, p.sanitize(list).count)
  end

  def test_train_count
    p = up_nw_stub
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
    p = up_nw_stub
    assert_equal(23, p.stop_count(p.tables[0][:tables][0]))
  end

  def test_make_stop_inbound
    p = up_nw_stub

    node = p.tables[0][:tables][0].xpath("tbody[4]/tr/td[1]")[0]
    expected = MetraSchedule::Stop.new :station => :crystal_lake, :time => Time.parse("4:47AM")
    assert_equal(expected.station, p.make_stop(node, 3, :inbound).station)
    assert_equal(expected.time, p.make_stop(node, 3, :inbound).time)
  end

  def test_make_stop_outbound
    p = up_nw_stub

    node = p.tables[3][:tables][0].xpath("tbody[4]/tr/td[1]")[0]
    expected = MetraSchedule::Stop.new :station => :jefferson_park, :time => Time.parse("6:13AM")
    assert_equal(expected.station, p.make_stop(node, 3, :outbound).station)
    assert_equal(expected.time, p.make_stop(node, 3, :outbound).time)
  end

  def test_make_stop_nil
    p = up_nw_stub

    node = p.tables[0][:tables][0].xpath("tbody[1]/tr/td[1]")[0]
    assert_nil(p.make_stop(node, 0, :inbound))
  end

  def test_make_stop_am
    p = up_nw_stub

    node = p.tables[0][:tables][1].xpath("tbody[18]/tr/td[5]")[0]
    expected = MetraSchedule::Stop.new :station => :norwood_park, :time => Time.parse("11:57AM")
    assert_equal(expected.station, p.make_stop(node, 17, :inbound).station)
    assert_equal(expected.time, p.make_stop(node, 17, :inbound).time)
  end

  def test_make_stop_pm
    p = up_nw_stub

    node = p.tables[0][:tables][1].xpath("tbody[20]/tr/td[5]")[0]
    expected = MetraSchedule::Stop.new :station => :jefferson_park, :time => Time.parse("12:01PM")
    assert_equal(expected.station, p.make_stop(node, 19, :inbound).station)
    assert_equal(expected.time, p.make_stop(node, 19, :inbound).time)
  end

  def test_find_stops
    p = up_nw_stub

    table = p.tables[0][:tables][0]
    assert_equal(19, p.find_stops(table, 1, :inbound).count)
  end

  def test_find_stops_express
    p = up_nw_stub

    table = p.tables[0][:tables][0]
    stops = p.find_stops(table, 5, :inbound)
    assert_equal(Time.parse("6:43AM").to_f , stops[6].time.to_f)
    assert_equal(:arlington_park, stops[6].station)
    assert_equal(10, stops.count)
  end

  def test_make_trains_count
    p = up_nw_stub
    trains = p.make_trains
    assert_equal(104, p.make_trains.count)
  end

  def test_find_train_num
    p = up_nw_stub
    train_602 = p.make_trains.first
    train_632 = p.make_trains[15]

    assert_equal(602, train_602.train_num)
    assert_equal(632, train_632.train_num)
  end

end

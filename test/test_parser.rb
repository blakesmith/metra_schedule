require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase
  include MetraSchedule::TrainData

  def up_nw_stub
    f = File.open(File.join(File.dirname(__FILE__), 'fixture/UP_NW.html'), 'r')
    parser = MetraSchedule::Parser.new f
    parser.line = LINES[:up_nw]
    parser
  end

  def test_init
    assert_nothing_raised do
      MetraSchedule::Parser.new 'http://blake.com'
    end
    assert_not_nil(up_nw_stub.html_doc)
  end

  def test_seperate_tables
    p = up_nw_stub
    p.seperate_tables
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
    p.seperate_tables
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
    p.seperate_tables
    assert_equal(23, p.stop_count(p.tables[0][:tables][0]))
  end

  def test_make_stop_inbound
    p = up_nw_stub
    p.seperate_tables

    node = p.tables[0][:tables][0].xpath("tbody[4]/tr/td[1]")[0]
    expected = MetraSchedule::Stop.new :station => :crystal_lake, :time => Time.parse("4:47AM")
    assert_equal(expected.station, p.make_stop(node, 3, :inbound).station)
    assert_equal(expected.time, p.make_stop(node, 3, :inbound).time)
  end

  def test_make_stop_outbound
    p = up_nw_stub
    p.seperate_tables

    node = p.tables[3][:tables][0].xpath("tbody[4]/tr/td[1]")[0]
    expected = MetraSchedule::Stop.new :station => :jefferson_park, :time => Time.parse("6:13AM")
    assert_equal(expected.station, p.make_stop(node, 3, :outbound).station)
    assert_equal(expected.time, p.make_stop(node, 3, :outbound).time)
  end

end

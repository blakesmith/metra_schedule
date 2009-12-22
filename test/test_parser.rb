require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def up_nw_stub
    f = File.open(File.join(File.dirname(__FILE__), 'fixture/UP_NW.html'), 'r')
    MetraSchedule::Parser.new f
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

end

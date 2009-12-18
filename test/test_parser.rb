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

end

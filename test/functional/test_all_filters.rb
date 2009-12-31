require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestLine < Test::Unit::TestCase
  include MetraSchedule::TrainData

  def up_nw_stub
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/UP_NW.html'), 'r')
    parser = MetraSchedule::Parser.new f
    parser.line = LINES[:up_nw]
    line = Metra.new.line(:up_nw)
    line.engines = parser.scrape
    line
  end

  def test_all_filters
    up_nw_stub.from(:ogilve).to(:barrington).at(Time.parse("12:15PM")).on(Date.parse("Dec 30 2009"))
    assert_equal(1, up_nw_stub.trains.count)
  end
end

require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestLine < Test::Unit::TestCase
  include MetraSchedule::TrainData

  def setup
    f = File.open(File.join(File.dirname(__FILE__), '../fixture/UP_NW.html'), 'r')
    parser = MetraSchedule::Parser.new f
    parser.line = LINES[:up_nw]
    @line = Metra.new.line(:up_nw)
    @line.engines = parser.scrape
    @line
  end

  def test_all_filters
    @line.from(:ogilve).to(:barrington).at(Time.parse("11:29PM")).on(Date.parse("Dec 27 2009"))
    assert_equal(1, @line.trains.count)
    @line.from(:ogilve).to(:barrington).at(Time.parse("3:00AM")).on(Date.parse("Dec 27 2009"))
    assert_equal(7, @line.trains.count)
  end

end

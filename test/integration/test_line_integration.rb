require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestLine < Test::Unit::TestCase

  def test_load_schedule
    cleanup_cache_dir
    line = Metra.new.line(:up_nw).outbound
    line.load_schedule
    assert_not_nil(line.trains)
  end

  def test_inject_delays_filter
    cleanup_cache_dir
    data = [{:train_num => 602, :delay => (10..15)}]
    result = MetraSchedule::Cacher.new.persist_delays(data)
    assert_equal(true, result)
    line = Metra.new.line(:up_nw).from(:barrington).to(:ogilve)
    line.load_schedule
    trains = line.trains
    the_602 = trains.find {|t| t.train_num == 602}
    assert_not_nil(the_602)
    assert_not_nil(the_602.delay)
    assert_equal(data.first[:delay], the_602.delay)
    cleanup_cache_dir
  end


end

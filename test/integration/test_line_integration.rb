require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestLine < Test::Unit::TestCase

  def test_load_schedule
    cleanup_cache_dir
    line = Metra.new.line(:up_nw).outbound
    line.load_schedule
    assert_not_nil(line.trains)
  end

end

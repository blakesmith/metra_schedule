require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def test_initialize_with_line_name
    assert_nothing_raised do
      Metra.new.line(:up_nw)
    end
  end

  def test_has_name_and_url
    line = Metra.new.line(:up_nw)
    assert_equal("Union Pacific Northwest", line.name)
    assert_equal("http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/up-nw/schedule.full.html", line.url)
  end

end

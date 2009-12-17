require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def test_initialize_with_line_name
    assert_nothing_raised do
      Metra.new.line(:up_nw)
    end
    assert_raise ArgumentError do
      Metra.new.line("blah")
    end
  end

  def test_initialize_with_incorrect_line_symbol
    assert_raise ArgumentError do
      Metra.new.line(:blah)
    end
  end

  def test_has_name_and_url
    line = Metra.new.line(:up_nw)
    assert_equal("Union Pacific Northwest", line.name)
    assert_equal("http://metrarail.com/metra/en/home/maps_schedules/metra_system_map/up-nw/schedule.full.html", line.url)
  end

  def test_direction
    line = Metra.new.line(:up_nw)
    assert_nothing_raised do
      line.direction :outbound
    end
    assert_equal(:outbound, line.dir)
    assert_nothing_raised do
      line.direction :inbound
    end
    assert_equal(:inbound, line.dir)
    assert_equal(line.direction.class, Metra.new.line(:up_nw).class)
  end

  def test_direction_incorrect_argument
    assert_raise ArgumentError do
      line = Metra.new.line(:up_nw).direction(:blah)
    end
  end

end

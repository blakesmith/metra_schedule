require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def test_init
    assert_nothing_raised do
      MetraSchedule::Parser.new 'http://blake.com'
    end
  end

end

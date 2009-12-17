require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestMetra < Test::Unit::TestCase
  def test_metra_init
    assert_nothing_raised do
      @m = Metra.new
    end
  end
end

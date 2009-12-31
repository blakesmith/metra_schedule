require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestMetra < Test::Unit::TestCase
  def test_metra_init
    assert_nothing_raised do
      @m = Metra.new
    end
  end
end

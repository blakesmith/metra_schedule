require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestDateExtension < Test::Unit::TestCase
  def test_to_time
    date = Date.parse('2010-05-22')
    assert_equal(Time.local(2010,05,22,0,0,0), date.to_time)
  end
end


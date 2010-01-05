require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestTimeExtension < Test::Unit::TestCase

  def test_to_today
    sample = Time.local(2009, 5, 5, 7, 30, 45)
    today = Time.now
    expected = Time.local(today.year, today.month, today.day, sample.hour, sample.min, sample.sec)
    assert_equal(expected, sample.to_today)
  end

end

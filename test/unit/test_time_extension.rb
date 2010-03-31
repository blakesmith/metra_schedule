require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestTimeExtension < Test::Unit::TestCase

  def test_to_today
    sample = Time.local(2009, 5, 5, 7, 30, 45)
    today = Time.now
    expected = Time.local(today.year, today.month, today.day, sample.hour, sample.min, sample.sec)
    assert_equal(expected, sample.to_today)
  end

  def test_to_today_midnight_inclusive
    Timecop.freeze(2009, 8, 28, 9, 30, 45)
    sample = Time.local(2009, 5, 5, 0, 30, 45)
    today = Time.now
    expected = Time.local(2009, 8, 29, 0, 30, 45)
    assert_equal(expected, sample.to_today)
  end

  def test_to_today_on_31st
    Timecop.freeze(2010, 3, 31, 9, 30, 45)
    sample = Time.local(2009, 5, 5, 0, 30, 45)
    today = Time.now
    expected = Time.local(2010, 4, 1, 0, 30, 45)
    assert_equal(expected, sample.to_today)
  end

  def test_to_today_on_31st_in_dec_after_midnight
    Timecop.freeze(2010, 12, 31, 9, 30, 45)
    sample = Time.local(2009, 5, 5, 0, 30, 45)
    today = Time.now
    expected = Time.local(2011, 1, 1, 0, 30, 45)
    assert_equal(expected, sample.to_today)
  end

  def test_to_today_in_dec_after_midnight
    Timecop.freeze(2010, 12, 21, 9, 30, 45)
    sample = Time.local(2009, 5, 5, 0, 30, 45)
    today = Time.now
    expected = Time.local(2010, 12, 22, 0, 30, 45)
    assert_equal(expected, sample.to_today)
  end

  def test_to_today_in_dec_before_midnight
    Timecop.freeze(2010, 12, 21, 9, 30, 45)
    sample = Time.local(2009, 5, 5, 11, 30, 45)
    today = Time.now
    expected = Time.local(2010, 12, 21, 11, 30, 45)
    assert_equal(expected, sample.to_today)
  end

end

require File.join(File.dirname(__FILE__), "../", "test_helper.rb")

class TestTimeExtension < Test::Unit::TestCase

  def test_fast_forward
    sample = Time.local(2009, 5, 5, 7, 30, 45)
    today = Time.now
    expected = Time.local(today.year, today.month, today.day, sample.hour, sample.min, sample.sec)
    assert_equal(expected, sample.fast_forward)
  end

  def test_fast_forward_to_a_specified_date
    sample = Time.local(2009, 5, 5, 7, 30, 45)
    tomorrow = Time.now + 86400
    expected = Time.local(tomorrow.year, tomorrow.month, tomorrow.day, sample.hour, sample.min, sample.sec)
    assert_equal(expected, sample.fast_forward(tomorrow))
  end

  def test_fast_forward_midnight_inclusive
    Timecop.freeze(2009, 8, 28, 9, 30, 45) do
      sample = Time.local(2009, 5, 5, 0, 30, 45)
      today = Time.now
      expected = Time.local(2009, 8, 29, 0, 30, 45)
      assert_equal(expected, sample.fast_forward)
    end
  end

  def test_fast_forward_on_31st
    Timecop.freeze(2010, 3, 31, 9, 30, 45) do
      sample = Time.local(2009, 5, 5, 0, 30, 45)
      today = Time.now
      expected = Time.local(2010, 4, 1, 0, 30, 45)
      assert_equal(expected, sample.fast_forward)
    end
  end

  def test_fast_forward_on_31st_in_dec_after_midnight
    Timecop.freeze(2010, 12, 31, 9, 30, 45) do
      sample = Time.local(2009, 5, 5, 0, 30, 45)
      today = Time.now
      expected = Time.local(2011, 1, 1, 0, 30, 45)
      assert_equal(expected, sample.fast_forward)
    end
  end

  def test_fast_forward_in_dec_after_midnight
    Timecop.freeze(2010, 12, 21, 9, 30, 45) do
      sample = Time.local(2009, 5, 5, 0, 30, 45)
      today = Time.now
      expected = Time.local(2010, 12, 22, 0, 30, 45)
      assert_equal(expected, sample.fast_forward)
    end
  end

  def test_fast_forward_in_dec_before_midnight
    Timecop.freeze(2010, 12, 21, 9, 30, 45) do
      sample = Time.local(2009, 5, 5, 11, 30, 45)
      today = Time.now
      expected = Time.local(2010, 12, 21, 11, 30, 45)
      assert_equal(expected, sample.fast_forward)
    end
  end

end

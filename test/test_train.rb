require 'test/unit'
require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def test_initialize_empty_options
    assert_nothing_raised do
      t = MetraSchedule::Train.new
    end
  end

  def test_initialize_one_option
    assert_nothing_raised do
      @@t = MetraSchedule::Train.new :train_num => 651
    end
    assert_equal(651, @@t.train_num)
  end

  def test_initialize_two_options
    assert_nothing_raised do
      @@t = MetraSchedule::Train.new :train_num => 651, :bikes => 12
    end
    assert_equal(651, @@t.train_num)
    assert_equal(12, @@t.bikes)
  end

  def test_initialize_all_options
    assert_nothing_raised do
      @@t = MetraSchedule::Train.new :train_num => 651, :bikes => 12, :schedule => :weekday, :direction => :outbound
    end
    assert_equal(651, @@t.train_num)
    assert_equal(12, @@t.bikes)
    assert_equal(:weekday, @@t.schedule)
    assert_equal(:outbound, @@t.direction)
  end

end

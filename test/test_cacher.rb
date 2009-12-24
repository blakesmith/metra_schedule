require 'test/unit'
require 'fileutils'

require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def cleanup_dir
    FileUtils.rmtree(MetraSchedule::Cacher.new.cache_dir)
  end

  def test_init
    assert_nothing_raised do
      MetraSchedule::Cacher.new
    end
  end

  def test_check_for_and_create_metra_cache_dir
    cleanup_dir
    c = MetraSchedule::Cacher.new
    assert_equal(false, c.check_for_metra_cache_dir)
    c.create_metra_cache_dir
    assert_equal(true, c.check_for_metra_cache_dir)
    cleanup_dir
  end

  def test_create_cache_dir_if_not_exists
    cleanup_dir
    c = MetraSchedule::Cacher.new
    assert_equal(false, c.check_for_metra_cache_dir)
    assert_equal(true, c.create_cache_dir_if_not_exists)
    cleanup_dir
  end

  def test_check_if_line_cache_file_exists
    cleanup_dir
    c = MetraSchedule::Cacher.new
    l = Metra.new.line(:up_nw) 
    c.create_cache_dir_if_not_exists
    assert_equal(false, c.line_exists?(l))
    cleanup_dir
  end

  def test_create_engine_cache
    cleanup_dir
    c = MetraSchedule::Cacher.new
    line = Metra.new.line(:up_nw) 
    c.create_cache_dir_if_not_exists

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:30')
    stop3 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :stops => [stop1, stop2, stop3], :direction => :outbound, :schedule => :weekday
    train2 = MetraSchedule::Train.new :stops => [stop1, stop3], :direction => :outbound, :schedule => :weekday
    train3 = MetraSchedule::Train.new :stops => [stop2, stop3], :direction => :outbound, :schedule => :weekday
    line.engines = [train1, train2, train3]

    assert_equal(true, c.persist_line(line))
    assert_equal(line.engines.count, c.retrieve_line(line).engines.count)
    cleanup_dir
  end

  def test_load_cache
    cleanup_dir
    c = MetraSchedule::Cacher.new
    line = Metra.new.line(:up_nw) 
    c.create_cache_dir_if_not_exists

    stop1 = MetraSchedule::Stop.new :station => :barrington, :time => Time.parse('12:30')
    stop2 = MetraSchedule::Stop.new :station => :arlington_heights, :time => Time.parse('12:30')
    stop3 = MetraSchedule::Stop.new :station => :ogilve, :time => Time.parse('13:30')
    train1 = MetraSchedule::Train.new :stops => [stop1, stop2, stop3], :direction => :outbound, :schedule => :weekday
    train2 = MetraSchedule::Train.new :stops => [stop1, stop3], :direction => :outbound, :schedule => :weekday
    train3 = MetraSchedule::Train.new :stops => [stop2, stop3], :direction => :outbound, :schedule => :weekday
    line.engines = [train1, train2, train3]

    assert_equal(true, MetraSchedule::Cacher.store_to_cache(line))
    assert_equal(c.retrieve_line(line).engines.count, MetraSchedule::Cacher.load_from_cache(line).engines.count)
    cleanup_dir
  end

end

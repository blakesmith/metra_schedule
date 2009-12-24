require 'test/unit'
require 'fileutils'

require File.join(File.dirname(__FILE__), "../lib", "metra")

class TestLine < Test::Unit::TestCase

  def cleanup_dir
    FileUtils.rmdir(MetraSchedule::Cacher.new.cache_dir)
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
end

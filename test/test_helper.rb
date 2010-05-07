require 'date'
require 'time'
require 'test/unit'
require 'fileutils'
require 'rubygems'
require 'bundler'

Bundler.setup :test

require 'mocha'
require 'timecop'

require File.join(File.dirname(__FILE__), "../lib", "metra")

module TestUnit
  module TestHelper

    def cleanup_cache_dir
      FileUtils.rmtree(MetraSchedule::Cacher.new.cache_dir)
    end

  end
end

Test::Unit::TestCase.send(:include, TestUnit::TestHelper)

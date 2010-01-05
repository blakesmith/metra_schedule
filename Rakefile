require 'rake'
require 'rake/testtask'

task :default => [:test]

desc "Run unit tests (functionals fail on win32)"
task :test => [:test_units, :test_functionals]

desc "Run just the unit tests"
Rake::TestTask.new(:test_units) do |t|
  t.test_files = FileList['test/unit/test*.rb']
  t.warning = false
end

Rake::TestTask.new(:test_functionals) do |t|
  t.test_files = FileList['test/functional/test*.rb']
  t.warning = false
end

Rake::TestTask.new(:test_integrations) do |t|
  t.test_files = FileList['test/integration/test*.rb']
  t.warning = false
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "metra_schedule"
    gemspec.summary = "Chicago Metra parser and scheduler"
    gemspec.description = "metra_schedule provides a ruby object interface to the Chicago metra train schedule"
    gemspec.email = "blakesmith0@gmail.com"
    gemspec.homepage = "http://github.com/blakesmith/metra_schedule"
    gemspec.authors = ["Blake Smith"]
    gemspec.add_dependency('nokogiri', '>=1.4.1')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end


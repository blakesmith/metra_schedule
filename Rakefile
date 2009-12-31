require 'rake'
require 'rake/testtask'

task :default => [:test]

desc "Run unit tests (functionals fail on win32)"
task :test => [:test_units]

desc "Run just the unit tests"
Rake::TestTask.new(:test_units) do |t|
  t.test_files = FileList['test/unit/test*.rb']
  t.warning = false
end

Rake::TestTask.new(:test_functionals) do |t|
  t.test_files = FileList['test/functionals/test*.rb']
  t.warning = false
end

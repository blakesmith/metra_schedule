Gem::Specification.new do |s|
  s.name = %q{metra_schedule}
  s.version = "0.2.1.2"
  s.has_rdoc = true
  s.date = %q{2010-1-05}
  s.authors = ["Blake Smith"]
  s.email = %q{blakesmith0@gmail.com}
  s.summary = %q{metra_schedule provides a ruby object interface to the Chicago metra train schedule.}
  s.homepage = %q{http://github.com/blakesmith/metra_schedule}
  s.description = %q{metra_schedule provides a ruby object interface to the Chicago metra train schedule.}
  s.files = ["Rakefile", "LICENSE", "README.rdoc", "lib/metra.rb", "lib/metra/cacher.rb", "lib/metra/classmethods.rb", "lib/metra/line.rb", "lib/metra/parser.rb", "lib/metra/stop.rb", "lib/metra/train.rb", "lib/metra/train_data.rb", "lib/metra/extensions/time_extension.rb","test/test_helper.rb", "test/fixture/UP_NW.html", "test/unit/test_cacher.rb", "test/unit/test_line.rb", "test/unit/test_metra.rb", "test/unit/test_parser.rb", "test/unit/test_stop.rb", "test/unit/test_train.rb", "test/functional/test_all_filters.rb", "test/integration/test_line_integration.rb", "test/unit/test_time_extension.rb"]


  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
 
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.1"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.4.1"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.4.1"])
  end
  
end

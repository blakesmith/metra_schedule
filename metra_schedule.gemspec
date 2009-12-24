Gem::Specification.new do |s|
  s.name = %q{metra_schedule}
  s.version = "0.1"
  s.has_rdoc = true
  s.date = %q{2009-12-24}
  s.authors = ["Blake Smith"]
  s.email = %q{blakesmith0@gmail.com}
  s.summary = %q{metra_schedule provides a ruby object interface to the Chicago metra train schedule.}
  s.homepage = %q{http://github.com/blakesmith/metra_schedule}
  s.description = %q{metra_schedule provides a ruby object interface to the Chicago metra train schedule.}
  s.files = ["Rakefile", "LICENSE", "README.rdoc", "lib/metra.rb", "lib/metra/cacher.rb", "lib/metra/classmethods.rb", "lib/metra/line.rb", "lib/metra/parser.rb", "lib/metra/stop.rb", "lib/metra/train.rb", "lib/metra/train_data.rb", "test/fixture/UP_NW.html", "test/test_cacher.rb", "test/test_line.rb", "test/test_metra.rb", "test/test_parser.rb", "test/test_stop.rb", "test/test_train.rb"]


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

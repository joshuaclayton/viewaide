require "rake"
require "rake/testtask"
require "rcov/rcovtask"

begin
  require "jeweler"
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "viewaide"
    gemspec.description = "Making your views easier"
    gemspec.summary = "Making your views easier"
    gemspec.email = "joshua.clayton@gmail.com"
    gemspec.homepage = "http://github.com/joshuaclayton/viewaide"
    gemspec.authors = ["Joshua Clayton"]
    gemspec.add_dependency("actionpack", ">= 2.1.0")
    gemspec.add_dependency("activesupport", ">= 2.1.0")
    gemspec.add_dependency("hpricot", ">= 0.8.1")
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
  t.verbose = true
end

task :default => [:test]

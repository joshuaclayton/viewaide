# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{viewaide}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Clayton"]
  s.date = %q{2010-01-09}
  s.description = %q{Making your views easier}
  s.email = %q{joshua.clayton@gmail.com}
  s.files = ["viewaide.gemspec", "Rakefile", "test/date_helper_test.rb", "test/form_helper_test.rb", "test/grid_helper_test.rb", "test/jquery_helper_test.rb", "test/link_helper_test.rb", "test/message_helper_test.rb", "test/navigation_helper_test.rb", "test/rjs_helper_test.rb", "test/structure_helper_test.rb", "test/table_helper_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/joshuaclayton/viewaide}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Viewaide", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{viewaide}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Making your views easier}
  s.test_files = ["test/date_helper_test.rb", "test/form_helper_test.rb", "test/grid_helper_test.rb", "test/jquery_helper_test.rb", "test/link_helper_test.rb", "test/message_helper_test.rb", "test/navigation_helper_test.rb", "test/rjs_helper_test.rb", "test/structure_helper_test.rb", "test/table_helper_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<actionview>, [">= 2.1.0"])
      s.add_development_dependency(%q<activesupport>, [">= 2.1.0"])
      s.add_development_dependency(%q<hpricot>, [">= 0.8.1"])
    else
      s.add_dependency(%q<actionview>, [">= 2.1.0"])
      s.add_dependency(%q<activesupport>, [">= 2.1.0"])
      s.add_dependency(%q<hpricot>, [">= 0.8.1"])
    end
  else
    s.add_dependency(%q<actionview>, [">= 2.1.0"])
    s.add_dependency(%q<activesupport>, [">= 2.1.0"])
    s.add_dependency(%q<hpricot>, [">= 0.8.1"])
  end
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-modulr}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex MacCaw"]
  s.date = %q{2011-02-21}
  s.email = %q{maccman@gmail.com}
  s.files = ["README.md", "Rakefile", "lib/rack", "lib/rack/modulr", "lib/rack/modulr/base.rb", "lib/rack/modulr/options.rb", "lib/rack/modulr/request.rb", "lib/rack/modulr/response.rb", "lib/rack/modulr/source.rb", "lib/rack/modulr/version.rb", "lib/rack/modulr.rb"]
  s.homepage = %q{http://github.com/maccman/rack-modulr}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{CommonJS modules for Ruby web apps.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0.4"])
      s.add_runtime_dependency(%q<modulr>, [">= 0.7.1"])
    else
      s.add_dependency(%q<rack>, [">= 0.4"])
      s.add_dependency(%q<modulr>, [">= 0.7.1"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0.4"])
    s.add_dependency(%q<modulr>, [">= 0.7.1"])
  end
end

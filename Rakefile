require 'rubygems'
require 'rake/gempackagetask'

require 'lib/rack/modulr/version'

spec = Gem::Specification.new do |s|
  s.name             = 'rack-modulr'
  s.version          = RackModulr::Version.to_s
  s.summary          = "CommonJS modules for Ruby web apps."
  s.author           = 'Alex MacCaw'
  s.email            = 'maccman@gmail.com'
  s.homepage         = 'http://github.com/maccman/rack-modulr'
  s.files            = %w(README.md Rakefile) + Dir.glob("{lib}/**/*")

  s.add_dependency("rack", [">= 0.4"])
  s.add_dependency("modulr", [">= 0.7.1"])
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Generate the gemspec to serve this gem'
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

task :default => :gem

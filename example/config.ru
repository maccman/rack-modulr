$: << File.join(File.dirname(__FILE__), *%w[ .. lib ])
require "rack/modulr"

use Rack::Modulr

Rack::Modulr.configure do |config|
  config.custom_loader = true
  config.cache  = false
  config.minify = false
end

run Rack::Directory.new("public")
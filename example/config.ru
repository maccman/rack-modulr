$: << File.join(File.dirname(__FILE__), *%w[ .. lib ])
require "rack/modulr"

use Rack::Modulr, :modulr => {:minify => false}

run Rack::Directory.new("public")
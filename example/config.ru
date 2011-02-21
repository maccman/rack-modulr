$: << File.join(File.dirname(__FILE__), *%w[ .. lib ])
require "rack/modulr"

use Rack::Modulr, :modulr => {:minify => true, :custom_loader => true}

run Rack::Directory.new("public")
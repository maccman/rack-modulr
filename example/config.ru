$: << File.join(File.dirname(__FILE__), *%w[ .. lib ])
require "rack/modulr"

use Rack::Modulr, :modulr => {:minify => true}

run Proc.new { [200, {"Content-Type" => "text/html"}, []] }
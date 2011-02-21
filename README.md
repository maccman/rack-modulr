[rack-modulr](http://github.com/maccman/rack-modulr) lets you easily use [Common.JS](http://www.sitepen.com/blog/2010/07/16/asynchronous-commonjs-modules-for-the-browser-and-introducing-transporter/) modules in your Rack/Rails applications. 

##Prerequisites

Although not required, it's recommended you use [this custom version](https://github.com/maccman/modulr) of the Modulr gem.

##Usage

For example with Rack:

    require "rack/modulr"

    use Rack::Modulr, :modulr => {:minify => true}
    run Proc.new { [200, {"Content-Type" => "text/html"}, []] }

Or with Rails:

    // Gemfile

    gem "modulr",      :git => "git://github.com/maccman/modulr.git"    
    gem "rack-modulr", :git => "git://github.com/maccman/rack-modulr.git"
    
    // config/application.rb
    require "rack/modulr"
    config.middleware.use "Rack::Modulr"
    
Then any modules in `app/javascripts` will be automatically parsed by [Modulr](https://github.com/maccman/modulr)
  
    // app/javascripts/utils.js    
    exports.sum = function(val1, val2){
      return(val1 + val2);
    };
    
    // app/javascripts/application.js
    var utils = require("./utils");
    console.log(utils.sum(1, 2));
    
When the browser requests a module, all its dependencies will be recursively resolved.

    $ curl "http://localhost:5001/javascripts/application.js"
   
    (function() {
      require.define({
        'utils': function(require, exports, module) {
          exports.sum = function(val1, val2){
            return(val1 + val2);
          };
        }
      });
      
      require.ensure(['utils'], function(require) {
        var utils = require("./utils");
        console.log(utils.sum(1, 2));
      });
    })();

Modulr injects a module loader library but if you want to use a different one, like  [Yabble](https://github.com/jbrantly/yabble), you'll need to pass the `:custom_loader` option to `Rack::Modulr`:
  
    use Rack::Modulr, :modulr => {:custom_loader => true}
    
Rack::Modulr caches the compiled modules in memory. Every request, the request module will be checked, to see if it's mtime has changed. If the module hasn't been changed, it'll be served from memory if possible. 

By defaulting, caching and minification are turned off. To turn them on in the production environment, for example, set the global settings on Rack::Modulr.
    
    // production.rb
    Rack::Modulr.configure do |config|
      config.cache  = true
      config.minify = true
    end

----------------------------------------------------  
  
Based on [Kelly Redding's](https://github.com/kelredd) great work on [rack-less](http://github.com/kelredd/rack-less).
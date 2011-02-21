require 'rack'
require 'rack/modulr/base'
require 'rack/modulr/config'
require 'rack/modulr/request'
require 'rack/modulr/response'
require 'rack/modulr/source'

# === Usage
#
# Create with default configs:
#   require 'rack/modulr'
#   Rack::Modulr.new(app)
#
# Within a rackup file (or with Rack::Builder):
#   require 'rack/modulr'
#
#   use Rack::Modulr,
#     :source   => 'app/modulr'
#
#   run app

module Rack::Modulr
  MIME_TYPE = "text/javascript"

  class << self
    # Configuration accessors for Rack::Modulr
    # (see config.rb for details)
    def configure
      yield config if block_given?
    end
  
    def config
      @config ||= Config.new
    end
  
    def config=(value)
      @config = value
    end
  end
  
  # Create a new Rack::Modulr middleware component 
  # => the +options+ Hash can be used to specify default configuration values
  # => (see Rack::Modulr::Options for possible key/values)
  def self.new(app, options={}, &block)
    Base.new(app, options, &block)
  end
end
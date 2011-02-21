require 'rack/response'
require 'rack/utils'

module Rack::Modulr

  # Given some generated js, mimicks a Rack::Response
  # => call to_rack to build standard rack response parameters
  class Response
    include Rack::Modulr::Options
    include Rack::Response::Helpers

    # Rack response tuple accessors.
    attr_accessor :status, :headers, :body, :source, :env

    def initialize(env, source)
      @env     = env
      @source  = source
      @body    = source.to_js
      @status  = 200 # OK
      @headers = Rack::Utils::HeaderHash.new     
    end
    
    def to_rack
      headers["Content-Type"]   = Rack::Modulr::MIME_TYPE
      headers["Content-Length"] = self.content_length.to_s
      
      [status, headers.to_hash, env["REQUEST_METHOD"] == "HEAD" ? [] : [body]]
    end
    
    def last_modified
      source.mtime
    end
    
    def md5
      source.md5
    end
  
    def content_length
      if body.respond_to?(:bytesize)
        body.bytesize
      else
        body.size
      end
    end
  end
end
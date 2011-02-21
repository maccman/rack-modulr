require 'rack/modulr/options'
require 'rack/modulr/request'
require 'rack/modulr/response'

module Rack::Modulr
  class Base
    include Rack::Modulr::Options
    YEAR_IN_SECONDS = 31540000

    def initialize(app, options = {})
      @app = app
      initialize_options options
      yield self if block_given?
      validate_options
    end

    # If CommonJS modules are being requested, this is an endpoint:
    # => generate the compiled js
    # => respond appropriately
    # Otherwise, call on up to the app as normal
    def call(env)
      @default_options.each { |k,v| env[k] ||= v }
      @env = env.dup.freeze

      if (@request = Request.new(@env)).for_modulr?
        response = Response.new(@env, source_for(@request))
        cache(response) { response.to_rack }
      else
        @app.call(env)
      end
    end

    protected
    
      def cache(response)
        env     = response.env
        headers = response.headers
        
        headers["Cache-Control"]  = "public, must-revalidate"
        if env["QUERY_STRING"] == response.md5
          headers["Cache-Control"] << ", max-age=#{YEAR_IN_SECONDS}"
        end

        headers["ETag"]           = %("#{response.md5}")
        headers["Last-Modified"]  = response.last_modified.httpdate
        
        if etag = env["HTTP_IF_NONE_MATCH"]
          return [304, headers.to_hash, []] if etag == headers["ETag"]
        end

        if time = env["HTTP_IF_MODIFIED_SINCE"]
          return [304, headers.to_hash, []] if time == headers["Last-Modified"]
        end
        
        yield
      end
      
      def source_for(request)
        @source ||= request.source
                
        previous_last_modified, @last_modified = @last_modified, @source.mtime
        unchanged = previous_last_modified == @last_modified
        
        unchanged ? @source : (@source = request.source)
      end

      def validate_options
        # ensure a root path is specified and does exists
        unless options.has_key?(option_name(:root)) and !options(:root).nil?
          raise(ArgumentError, "no :root option set")
        end
        set :root, File.expand_path(options(:root))

        # ensure a source path is specified and does exists
        unless options.has_key?(option_name(:source)) and !options(:source).nil?
          raise(ArgumentError, "no :source option set")
        end
      end
  end
end
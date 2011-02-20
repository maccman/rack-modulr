require 'rack/request'
require 'rack/modulr'
require 'rack/modulr/options'
require 'rack/modulr/source'

module Rack::Modulr

  # Provides access to the HTTP request.
  # Request objects respond to everything defined by Rack::Request
  # as well as some additional convenience methods defined here
  # => from: http://github.com/rtomayko/rack-cache/blob/master/lib/rack/cache/request.rb

  class Request < Rack::Request
    include Rack::Modulr::Options

    JS_PATH_FORMATS = ['.js']

    # The HTTP request method. This is the standard implementation of this
    # method but is respecified here due to libraries that attempt to modify
    # the behavior to respect POST tunnel method specifiers. We always want
    # the real request method.
    def request_method
      @env['REQUEST_METHOD']
    end

    def path_info
      @env['PATH_INFO']
    end

    def http_accept
      @env['HTTP_ACCEPT']
    end

    def path_resource_format
      File.extname(path_info)
    end

    def path_resource_name
      File.basename(path_info, path_resource_format)
    end

    def path_resource_source
      File.join(File.dirname(path_info).gsub(/#{options(:hosted_at)}/, ''), path_resource_name).gsub(/^\//, '')
    end

    def cache
      File.join(options(:root), options(:public), options(:hosted_at))
    end

    # The Rack::Modulr::Source that the request is for
    def source
      @source ||= begin
        source_opts = {
          :folder   => File.join(options(:root), options(:source))
        }.merge(Rack::Modulr.config.modulr)
        Source.new(path_resource_source, source_opts)
      end
    end

    def for_js?
      (http_accept && http_accept.include?(Rack::Modulr::MIME_TYPE)) ||
      (media_type  && media_type.include?(Rack::Modulr::MIME_TYPE )) ||
      JS_PATH_FORMATS.include?(path_resource_format)
    end

    def hosted_at?
      path_info =~ /^#{options(:hosted_at)}\//
    end

    def exists?
      File.exists?(File.join(cache, "#{path_resource_source}#{path_resource_format}"))
    end

    # Determine if the request is for existing CommonJS file
    # This will be called on every request so speed is an issue
    # => first check if the request is a GET on a js resource :hosted_at (fast)
    # => don't process if a file already exists in :hosted_at
    # => otherwise, check for modulr source files that match the request (slow)
    def for_modulr?
      get? &&
      for_js? &&
      hosted_at? &&
      !exists? &&
      !source.files.empty?
    end
  end
end
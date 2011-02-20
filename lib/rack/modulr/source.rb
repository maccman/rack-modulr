require 'modulr'

module Rack::Modulr

  # The engine for compiling CommonJS modules
  # Given the name of the modulr source file you want
  # to compile and a path to the source files,
  # will returns corresponding compiled JavaScript
  class Source

    # Source files with the .js extension
    PREFERRED_EXTENSIONS = [:js]

    attr_reader :path

    def initialize(path, options={})
      @path   = path
      @folder = get_required_path(options, :folder)
    end

    # Use named JS sources before using combination sources
    def files
      @files ||= preferred_sources([@path])
    end

    def compiled
      @compiled ||= Modulr.ize(files)
    end
    alias_method :to_js, :compiled
    alias_method :js, :compiled

    private

    # Given a list of sources, return a list of
    # existing source files with the corresponding source paths
    # honoring the preferred extension list
    def preferred_sources(paths)
      paths.collect do |source_path|
        PREFERRED_EXTENSIONS.inject(nil) do |source_file, extension|
          source_file || begin
            path = File.join(@folder, "#{source_path}.#{extension}")
            File.exists?(path) ? path : nil
          end
        end
      end.compact
    end

    def get_required_path(options, path_key)
      unless options.has_key?(path_key)
        raise(ArgumentError, "no :#{path_key} option specified")
      end
      unless File.exists?(options[path_key])
        raise(ArgumentError, "the :#{path_key} ('#{options[path_key]}') does not exist")
      end
      options[path_key]
    end
  end
end
module Rack::Modulr
  class Config
    
    ATTRIBUTES = [:cache, :minify, :modulr]
    attr_accessor *ATTRIBUTES
    
    DEFAULTS = {
      :cache  => false,
      :minify => false,
      :modulr => {}
    }

    def initialize(settings = {})
      ATTRIBUTES.each do |a|
        send("#{a}=", settings[a] || DEFAULTS[a])
      end
    end
    
    def modulr
      @modulr ||= {}
    end
    
    def minify=(val)
      self.modulr[:minify] = val
    end
    
    def custom_loader=(val)
      self.modulr[:custom_loader] = val
    end
    
    def cache?
      !!self.cache
    end
  end
end
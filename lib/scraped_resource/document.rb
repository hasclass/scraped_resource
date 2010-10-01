module ScrapedResource
  class Document < Base
    attr_reader :file_name

    def initialize(file_name)
      @file_name = file_name
    end

    ##
    # {:nav => 2, :other_column_name => 3}
    #
    def headers
      unless @headers_hash
        @headers_hash = if config.headers_proc
          config.headers_proc.call(self)
        else
          parse_headers
        end
      end
      @headers_hash
    end

    ##
    # 
    def inspect
      "<#{self.class.name} @file_name=#{file_name}>"
    end

    def self.config
      @config
    end

    def config
      self.class.config || {}
    end

    def ordered_keys
      self.class.attributes.keys
    end

    def self.reject_row?(row)
      reject_row_procs.any? do |block|
        block.call(row)
      end
    end

    def self.reject_row_procs
      @reject_row_procs ||= []
    end

    def self.reject_row_if(&block)
      reject_row_procs << block
    end

    def self.attributes
      @attributes || {}
    end

    def self.attribute(key, options = {}, &block)
      @attributes ||= {}
      options[:block] = block if block_given?
      @attributes[key] = options
    end
  end
end
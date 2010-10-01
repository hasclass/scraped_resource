require 'lib/scraped_resource/normalizer/base'
require 'lib/scraped_resource/normalizer/numeric'

module ScrapedResource
  class Row
    include Normalizer

    def initialize(document, attributes, cells)
      @document = document
      @attributes = attributes
      @cells = cells
    end

    def to_hash
      @attributes.keys.inject({}) {|hsh, key| hsh.merge key => self[key] }
    end

    def [](attribute_key)
      opts = @attributes[attribute_key]

      value = nil
      if column_name = opts[:key]
        raw_attr = ScrapedResource::Attribute.new(value_by_column_name(column_name), opts)
        value = raw_attr.value
      end
      if method_name = opts[:method]
        value = @document.send(method_name)
      end
      if default_value = opts[:default]
        value ||= default_value
      end
      if normalize = opts[:normalize]
        value = normalize_value([normalize].flatten, value)
      end
      if block = opts[:block]
        value = block.call(self, value) 
      end
      value
    end

    def normalize_value(normalizers, value)
      #normalizers.inject(value) {|v,n| send("to_#{n}", v)}
      # following is easier on the eyes:
      normalizers.each do |n|
        value = send("to_#{n}", value)
      end
      value
    end

    def value_by_column_name(col_name)
      col_name = col_name.detect{|col| @cells.keys.include?(col)} if col_name.is_a?(Array)
      @cells[col_name]
    end

    def method_missing(method_name, *args)
      if @attributes.has_key?(method_name.to_sym)
        self[method_name]
      else
        super
      end
    end
  end
end

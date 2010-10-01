module ScrapedResource
  class Attribute
    attr_reader :raw_value, :options

    def initialize(raw_value, options = {})
      @raw_value = raw_value
      @options = options
    end

    def value
      normalized_value
    end

    def to_float(v)
      v.to_f
    end

    def normalized_value
      format = if options[:date_format]
        raise "both :date_format and :format defined" if options.has_key?(:format)
        lambda {|text| (Date.strptime(text.to_s, options[:date_format]) rescue nil) if text.present? }
      else
        options[:format]
      end

      if format.is_a?(Proc)
        format.call(raw_value)
      elsif format.is_a?(Array)
        v = raw_value
        format.each do |format_method|
          v = formatting_method(format_method, v)
        end
        v
      elsif format.is_a?(Symbol)
        formatting_method(format, raw_value)
      else
        raw_value
      end
    end

    def formatting_method(format_method, value)
      raise "Invalid attribute format method: #{format_method}" unless respond_to?(format_method)
      send(format_method, value)
    end
  end
end
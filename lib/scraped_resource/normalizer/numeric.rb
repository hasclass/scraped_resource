module ScrapedResource
module Normalizer

  module NumericNormalizer
    def to_numeric(value, opts = {})
      NumericExtractor.new(value, opts).normalize
    end
  end

  include NumericNormalizer
  extend NumericNormalizer

  class NumericExtractor
    def initialize(str, opts = {})
      @str = str
      @options = opts
    end

    def normalize
      return @str if @str.is_a?(Numeric)
      return nil if @str.blank?
      return nil if clean.blank?
      delimiters_count = delimiters.uniq.length
      send("normalize_#{delimiters_count}_delimiters")
    end

  private

    def normalize_0_delimiters
      clean.to_f
    end

    def normalize_1_delimiters
      delimiter = delimiters.first
      if delimiters.length > 1 and components.length > 2 and components[1..-1].all?{|n| n.length == 3}
        # one delimiter that appears multiple times can only be a thousand separator
        clean.gsub(delimiter, '')
      else
        # figure out if delimiter is separator or delimiter
        # 1.03
        # 1.003 | tricky case
        # 1'003 | tricky case
        # 1000.3
        lft, rgt = clean.split(delimiter)
        if rgt and rgt.length == 3
          if separator = @options[:separator]
            separator == delimiter ? "#{lft}.#{rgt}" : "#{lft}#{rgt}"
          else
            raise "NumberExtractor: ambigous number: #{@str}" 
          end
        else
          "#{lft}.#{rgt}"
        end
      end.to_f
    end

    # 1.003,123 or 1,003.01
    # special case 1.120,123 not considered (rare)
    def normalize_2_delimiters
      if delimiters.select{|d| d == delimiters.last}.length > 1
        raise "more then one last delimiter for number: #{@str}"
      end
      lft,rgt = clean.split(delimiters.last)
      lft.gsub!(delimiters.first, '')
      "#{lft}.#{rgt}".to_f
    end

    # 1.003,123 or 1,003.01
    def normalize_3_delimiters
      lft,rgt = clean.split(delimiters.uniq[1])
      lft.gsub!(delimiters.first, '')
      rgt.gsub!(delimiters.last, '')
      "#{lft}.#{rgt}".to_f
    end

    def clean
      @str.gsub(/[^,'\.0-9]/, '')
    end

    def components
      @cmp ||= clean.split(/[,\.']/)
    end

    def delimiters
      @delimiters ||= clean.gsub(/[0-9]/, '').split('')
    end
  end

end
end
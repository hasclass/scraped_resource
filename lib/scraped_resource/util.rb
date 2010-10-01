module ScrapedResource
  class Utilities
    def self.class_name(klass)
      klass.name.split("::").last
    end

    def self.slug(str)
      str = str.downcase.strip.tr(" ", "_").delete("^a-z0-9_").gsub('__', '_').gsub(/_$/, '')
      str = 'undefined' if str.blank?
      str
    end

    def self.parse_number(str)
      NumberExtractor.new(str).normalize
    end
  end
end
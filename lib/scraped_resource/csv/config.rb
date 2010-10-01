module ScrapedResource::Csv
  class Config
    attr_accessor :line_separator, 
                  :column_separator

    attr_reader :headers_line, 
                :headers_proc

    def initialize(document, &block)
      @document = document
      self.line_separator = "\n"
      self.column_separator = ","
      yield self #if block_given?
    end

    def headers(*args, &block)
      arg, opts = args.first, args.extract_options! 
      @headers_line = arg || 0
      @headers_proc = block if block_given?
    end
  end
end
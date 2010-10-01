module ScrapedResource::Excel
  class Config
    attr_reader :headers_line, 
                :headers_proc,
                :document
    attr_writer :first_data_row

    def initialize(document, &block)
      @document = document
      yield self #if block_given?
    end

    def headers(*args, &block)
      arg, opts = args.first, args.extract_options! 
      @headers_line = arg || 0
      @headers_proc = block if block_given?
    end

    def first_data_row
      @first_data_row ||= @headers_line + 1
    end
  end
end
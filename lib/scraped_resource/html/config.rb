module ScrapedResource::Html
  class Config
    attr_reader :headers_path, 
                :headers_proc,
                :table_path, 
                :table_proc,
                :rows_path, 
                :rows_proc,
                :cell_path, 
                :cell_proc

    def initialize(document, &block)
      @document = document
      yield self #if block_given?
    end

    def headers(*args, &block)
      path, opts = args.first, args.extract_options! 
      @headers_path = path 
      @headers_proc = block if block_given?
    end

    def table(*args, &block)
      path, opts = args.first, args.extract_options! 
      @table_path = path
      @table_proc = block if block_given?
    end

    def rows(*args, &block)
      path, opts = args.first, args.extract_options! 
      @rows_path = path 
      @rows_proc = block if block_given?
    end

    def cells(*args, &block)
      path, opts = args.first, args.extract_options! 
      @cell_path = path
      @cell_proc = block if block_given?
    end

    def cell_values(*args)
      strategy = args.first
      @cell_value_strategy = strategy.to_sym
    end

    def cell_value_strategy
      @cell_value_strategy || :inner_text
    end

  end
end
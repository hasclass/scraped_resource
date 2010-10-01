module ScrapedResource::Html
  class Base < ScrapedResource::Document
    def self.extension
      'html'
    end

    def self.html_list(&block)
      @config = Config.new(self, &block)
    end

    ##
    #
    def rows
      unless @rows
        @rows = []
        each_row {|row| @rows << row }
      end
      @rows
    end

    alias_method :all, :rows
    alias_method :to_a, :rows

    ##
    #
    def document
      unless @document
        @document = Nokogiri(File.read(file_name))
      end
      @document
    end

    ##
    #
    def table
      @table ||= document.search(config.table_path)
    end

  private
    def parse_headers
      hsh = {}
      document.search(config.headers_path).each_with_index do |cell, i|
        key = cell.inner_text.strip.downcase rescue 'undefined'
        key = key.gsub(/\W+/, '_').to_sym if key.present?
        hsh[key] = i
      end
      hsh
    end

    def each_row(&block)
      table.search(config.rows_path).each do |row|
        row = row_to_hash(row)
        yield row unless self.class.reject_row?(row)
      end
    end

    def cells_hash(row)
      hsh = {}
      headers_reversed = headers.invert
      row.search(config.cell_path).each_with_index do |cell, col_number|
        if config.cell_value_strategy == :inner_text
          hsh[headers_reversed[col_number]] = cell.inner_text.strip.gsub("\r", "").gsub("\n", " ")
        else
          hsh[headers_reversed[col_number]] = cell.inner_html.strip.gsub("\r", "").gsub("\n", " ")
        end
      end
      hsh
    end

    def row_to_hash(row)
      r = ::ScrapedResource::Row.new(self, self.class.attributes, cells_hash(row))
      r.to_hash
    end
  end
end
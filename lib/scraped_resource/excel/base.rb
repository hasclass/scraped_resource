module ScrapedResource::Excel

  class Base < ScrapedResource::Document
    def self.excel_list(&block)
      @config = Config.new(self, &block)
    end

    def self.extension
      'xls'
    end

    def rows
      unless @rows
        @rows = []
        each_row {|row| @rows << row }
      end
      @rows
    end

    alias_method :all, :rows
    alias_method :to_a, :rows

    def document
      @document ||= Excel.new(file_name)
    end

  protected
    def headers_line
      config.headers_line
    end

    def first_data_row
      if headers_line
        [headers_line].flatten.last + 1
      else
        config.first_data_row
      end
    end


  private
    def parse_headers
      hsh = {}
      header_lines = [headers_line].flatten
      1.upto(document.last_column) do |column_number|
        key = header_lines.map{|l| document.cell(l, column_number) || ''}.join('_')
        key = ScrapedResource::Utilities.slug(key)
        key_sym = key.empty? ? :undefined : key.to_sym
        hsh[key_sym] ||= column_number
      end
      hsh
    end

    def each_row(&block)
      # if header_line is a proc, take first line
      (first_data_row).upto(document.last_row) do |line|
        row = row_to_hash(line)
        yield row unless self.class.reject_row?(row)
      end
    end

    def cells_hash(row_number)
      hsh = {}
      headers_reversed = headers.invert
      1.upto(document.last_column) do |col_number|
        hsh[headers_reversed[col_number]] = document.cell(row_number, col_number)
      end
      hsh
    end

    def row_to_arr(row_number)
      (1..document.last_column).to_a.map do |col_number|
        document.cell(row_number, col_number)
      end
    end

    def row_to_hash(row)
      r = ::ScrapedResource::Row.new(self, self.class.attributes, cells_hash(row))
      r.to_hash
    end
  end
end
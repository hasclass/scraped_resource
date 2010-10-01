require 'lib/scraped_resource/document'

module ScrapedResource::Csv
  class Base < ScrapedResource::Document
    def self.csv_list(&block)
      @config = Config.new(self, &block)
    end

    def self.extension
      'csv'
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
      @document ||= File.read(file_name)
    end

  private
    def parse_headers
      hsh = {}
      cells(lines[config.headers_line - 1]).each_with_index do |cell, column_number|
        key = cell.blank? ? 'undefined' : cell
        key_sym = ScrapedResource::Utilities.slug(key).to_sym
        hsh[key_sym] ||= column_number
      end
      hsh
    end

    def lines
      document.split(config.line_separator)
    end

    def cells(line)
      line.split(config.column_separator)
    end

    def each_row(&block)
      lines.each_with_index do |line, i|
        next if i < config.headers_line # headers_line starts with 1
        row = line_to_hash(line)
        yield row unless self.class.reject_row?(row)
      end
    end

    def cells_hash(row)
      hsh = {}
      headers_reversed = headers.invert
      row.each_with_index do |cell_value, col_number|
        hsh[headers_reversed[col_number]] = cell_value
      end
      hsh
    end

    def line_to_hash(line)
      row = cells(line)
      r = ::ScrapedResource::Row.new(self, self.class.attributes, cells_hash(row))
      r.to_hash
    end
  end
end
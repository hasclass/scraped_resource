module ScrapedResource::Remote
  ##
  # 
  #
  class LocalFile
    def self.attr_class_reader(*args)
      args.each do |name|
        define_method name do
          self.class.send(name)
        end
      end
    end

    class << self
      attr_accessor :path, :file_regexp, :ignore_invalid_excel
    end

    attr_class_reader :path, :file_regexp, :ignore_invalid_excel

    def initialize(&block)
      yield self if block_given?
    end

    def path
      p = self.class.path 
      p ||= ScrapedResource::Utilities.class_name_to_path(self.class)
      p.is_a?(Proc) ? p.call : p
    end

    ##
    #
    # @params pages [Array,Hash]
    # @return [String] filenames
    #
    def download_and_save(pages = nil)
      # already downloaded
      entries_in_base_path.select do |f| 
        valid_file = true
        if valid_file and file_regexp
          valid_file = false unless f.split('/').last =~ file_regexp
        end
        # only check if file is still valid
        if valid_file and ignore_invalid_excel == true
          begin
            Excel.new(f)
          rescue Ole::Storage::FormatError => e
            valid_file = false
          end
        end
        valid_file
      end
    end

    def entries_in_base_path
      Dir[base_path+"/*"]
    end

    def base_path
      "#{ScrapedResource::Base.options[:base_path]}/#{self.path || tmp_path}"
    end

    def tmp_path
      ::ScrapedResource::Utilities.class_name(self.class).downcase
    end
  end
end
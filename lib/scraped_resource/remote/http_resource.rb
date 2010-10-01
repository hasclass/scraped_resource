module ScrapedResource::Remote
  class HttpResource
    def self.attr_class_reader(*args)
      args.each do |name|
        define_method name do
          self.class.send(name)
        end
      end
    end

    class << self
      attr_accessor :extension, :path, :base_url, :pages
    end

    attr_class_reader :extension, :base_url, :pages
    attr_reader :resources

    def initialize(&block)
      yield self if block_given?
    end

    def path
      p = self.class.path
      p.is_a?(Proc) ? p.call : p
    end

    ##
    #
    # @params pages [Array,Hash]
    # @return [String] filenames
    #
    def download_and_save(pages = nil)
      save download(pages)
    end

    def download(pages = nil)
      pages ||= self.pages
      @resources ||= pages.map do |path,id|
        download_resource(path)
      end
    end

    def save(resources = resources)
      @file_names ||= resources.map do |r|
        save_file(r, "#{Date.today}-#{Time.now.to_i}-#{Time.now.usec}.#{extension}")
      end
    end

    def download_resource(path)
      file = agent.get("#{base_url}#{path}")
      puts "Downloaded: #{base_url}#{path}"
      file
    end

    def save_file(file, file_name = nil)
      FileUtils.mkdir_p(base_path)
      file_name ||= tmp_file_name
      full_path = "#{base_path}/#{file_name}"
      if file.respond_to?(:save_as)
        file.save_as(full_path)
        puts "Saved: #{full_path} (#{File.size(full_path) / 1000} KB)"
      end
      full_path
    end

    def agent
      self.class.agent
    end

    def self.agent
      Agent.instance
    end

    def base_path
      "#{ScrapedResource::Base.options[:base_path]}/#{self.path || tmp_path}"
    end

    def tmp_path
      ::ScrapedResource::Utilities.class_name(self.class).downcase
    end

    def tmp_file_name
      "#{Date.today}.#{extension}"
    end
  end
end
module ScrapedResource
  class Base
    include ScrapedResource::Normalizer
    extend ScrapedResource::Normalizer

    def self.list_remote; @list_remote; end
    def self.list_mapper; @list_mapper; end

    def self.map(key, hsh)
      if key.to_s == 'list'
        @list_remote, @list_mapper = hsh.keys.first, hsh.values.first
      else

      end
    end

    def self.options
      @options ||= {
        :base_path => 'tmp/scraped_resources'
      }.with_indifferent_access
    end

    def documents
      arr = []
      each_document {|d| arr << d}
      arr
    end

    def each_document(&block)
      return unless block_given?
      remote_resource = self.class.list_remote.new 
      files = remote_resource.download_and_save
      files.each do |f|
        yield self.class.list_mapper.new(f)
      end 
    end

    ##
    # for /list
    #
    def all
      arr = []
      each_document do |document|
        arr << document.to_a
      end
      arr.flatten
    end

    def remote_resource
      self.class.remote_resource
    end

    def self.remote_resource
      @remote_resource
    end

  protected
    ##
    # 
    # @return options [Hash]
    #
    def lookup(id)
      
    end
  end
end
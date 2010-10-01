module ScrapedResource::Remote
  class Agent < Mechanize 
    def self.instance
      unless @instance
        @instance = Mechanize.new
        @instance.max_history = 0
        @instance.user_agent_alias = 'Mac FireFox'      
      end
      @instance
    end
  end
end

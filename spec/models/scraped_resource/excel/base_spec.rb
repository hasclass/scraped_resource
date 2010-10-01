require 'spec_helper'

module ScrapedResource::Excel
  describe Base do
    it "should initialize" do
      Base.new('file_name')
    end
  end
end
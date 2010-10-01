require 'spec_helper'

module ScrapedResource

describe Base do

  describe "#options" do
    subject { Base.options }
    specify { Base.options[:base_path].should == 'tmp/scraped_resources'}
  end

  describe "#options[:base_path] = something_else" do
    before do
      @new_path = 'new_path'
      Base.options[:base_path] = @new_path
    end
    specify { Base.options[:base_path].should == @new_path}
  end

end

end
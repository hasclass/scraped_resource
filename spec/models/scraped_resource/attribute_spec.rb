require 'spec_helper'


module ScrapedResource


  describe Attribute do
    before { @attr = Attribute.new('100') }

    describe "one formatter" do
      before { 
        @attr = Attribute.new('100', :format => :to_float ) 
        @attr.should_receive(:to_float).with('100').and_return(100)
      }
      specify { @attr.value.should == 100 }
    end

    describe "format chain" do
      before { 
        @attr = Attribute.new('100', :format => [:chain_one, :chain_two] ) 
        @attr.should_receive(:chain_one).once.with('100').and_return(90)
        @attr.should_receive(:chain_two).once.with(90).and_return(80)
      }
      specify { @attr.value.should == 80 }
    end
  end

end

require 'spec_helper'


module ScrapedResource
  describe Row, '#normalize_value' do
    describe "one normalizer" do
      before { @row = Row.new(nil,nil,nil) }
      specify { @row.normalize_value([:numeric], "145.01").should == 145.01 }
    end
    describe "chained normalizers" do
      before do
        @row = Row.new(nil,nil,nil) 
        @row.should_receive(:to_foo).and_return(10)
      end
      specify { @row.normalize_value([:numeric, :foo], "145.01").should == 10 }
    end
  end
end

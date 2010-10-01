require 'spec_helper'


module ScrapedResource
  describe "floats" do
    before { @result = 1005.42}

    specify { n = "1005.42"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
    specify { n = "1005,42"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
    specify { n = "1,005,420"; Normalizer.to_numeric(n).should be_close(1005420.0, 0.001) }

    specify { n = "1 005.42"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
    specify { n = "1,005.42"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
    specify { n = "1'005.42"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
    specify { n = "1 a 005.42"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
    specify { n = "$ 1005.42"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
    specify { n = "1'005.420,000,251"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
  end
  describe "ints" do
    before { @result = 1005.0}
    specify { n = "1005"; Normalizer.to_numeric(n).should be_close(@result, 0.001) }
    specify { n = "1,005"; lambda { Normalizer.to_numeric(n).should be_close(@result, 0.001) }.should raise_error }
    specify { n = "1.005"; lambda { Normalizer.to_numeric(n).should be_close(@result, 0.001) }.should raise_error }
    specify { n = "1'005"; lambda { Normalizer.to_numeric(n).should be_close(@result, 0.001) }.should raise_error }

    specify { Normalizer.to_numeric("1,000", :separator => '.').should be_close(1000.0, 0.01) }
  end
end

require 'spec_helper'


module ScrapedResource
  describe Normalizer do
    specify { Normalizer.respond_to?(:to_numeric).should be_true}
  end
end

require 'spec_helper'


module ScrapedResource::Csv

  describe List do
    class Sample1 < ScrapedResource::Csv::List
      csv_list do |config|
        config.headers 1
      end
      attribute :name, :key => :name
    end

    before { @list = Sample1.new('spec/files/csv/sample.csv') }

    subject do
      @list
    end
    its(:document) { should_not be_nil }

    describe :headers do
      subject {@list.headers}

      it { should_not be_empty}
      it { should include(:name) }
    end

    describe :results do
      before { @results = @list.to_a }
      subject { @results }

      it { should have(2).items }
      specify { @results.any?{|r| r[:name] == 'Foo'}.should be_true }
      specify { @results.any?{|r| r[:name] == 'Hello'}.should be_true }
    end
  end

  describe List do
    class Sample2 < ScrapedResource::Csv::List
      csv_list do |config|
        config.headers 3
      end
      attribute :name, :key => :name
    end

    before { @list = Sample2.new('spec/files/csv/sample2.csv') }

    describe :headers do
      subject {@list.headers}
      it { should_not be_empty}
      it { should include(:name) }
    end

    describe :results do
      before { @results = @list.to_a }
      subject { @results }

      it { should have(2).items }
      specify { @results.any?{|r| r[:name] == 'Foo'}.should be_true }
      specify { @results.any?{|r| r[:name] == 'Hello'}.should be_true }
    end
  end

end

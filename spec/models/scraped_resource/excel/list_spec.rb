require 'spec_helper'


module ScrapedResource::Excel


  describe List do
    class Sample1 < ScrapedResource::Excel::List
      excel_list do |config|
        config.headers 5
      end

      attribute :name, :key => :name
      attribute :custom, :method => :custom_method
      attribute :list_of_names, :key => [:sym, :symbol]

      attribute :name_plus_foo do |row, value|
        "#{row[:name]}_plus"
      end

      attribute :block_with_column, :key => :name do |row, value|
        "#{value}_plus"
      end

      def custom_method
        'custom'
      end
    end

    before { @list = Sample1.new('spec/files/excel/sample1.xls') }

    subject do
      @list
    end

    its(:document) { should_not be_nil }

    describe :headers do
      subject {@list.headers}

      it { should_not be_empty}
      it { should include(:symbol) }
      it { should include(:indexanbieter) }
      it { should include(:symbol) }
    end

    describe :results do
      before { @results = @list.to_a }
      subject { @results }

      it { should have(4).items }
      specify { @results.any?{|r| r[:name] == 'Foo'}.should be_true }
      specify { @results.first.has_key?(:custom).should be_true }
      specify { @results.first[:list_of_names].should == '100GBA' }
      specify { @results.first[:custom].should == 'custom' }
      specify { @results.first[:name].should == 'Foo' }
      specify { @results.first[:name_plus_foo].should == 'Foo_plus' }
      specify { @results.first[:block_with_column].should == 'Foo_plus' }
    end
  end

  describe List, "#reject_row_if" do
    class SampleRejectRow < ScrapedResource::Excel::List
      excel_list do |config|
        config.headers 5
      end

      attribute :name, :key => :name

      reject_row_if {|row| row[:name].blank? }
      reject_row_if {|row| row[:name] == 'Baz' }
    end

    subject do
      SampleRejectRow.new('spec/files/excel/sample1.xls')
    end

    its(:to_a) { should have(2).items }
  end

  describe List, "#header" do
    class SampleHeaderWithBlock < ScrapedResource::Excel::List

      excel_list do |config|
        config.headers do |list|
          {:name => 1}
        end
      end

      attribute :name, :key => :name
    end

    subject do
      SampleHeaderWithBlock.new('spec/files/excel/sample1.xls')
    end
    its(:to_a) { should have(9).items }
  end
end

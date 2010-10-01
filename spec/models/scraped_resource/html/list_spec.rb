require 'spec_helper'


module ScrapedResource::Html
  describe List do
    class Xetra < ScrapedResource::Html::List
      html_list do |config|
        config.table 'table.fulldouble'
        config.rows 'tr.sorter ~ tr'
        config.cells 'td'
        config.cell_values :inner_html

        config.headers do |base|    
          hsh = {}
          base.document./("table.fulldouble:first-of-type tr")[0]./("th").each_with_index do |cells, i|
            txt = cells.inner_text || 'undefined'
            hsh[ScrapedResource::Utilities.slug(txt).to_sym] = i 
          end
          hsh
        end
      end

      attribute :isin, :key => :nameisin do |row, value| value.split('<br>').last; end
      attribute :default, :default => 'foo'
      attribute :custom, :method => :custom_method
      attribute :list_of_names, :key => [:sym, :symbol]
      attribute :name_plus_foo do |row, value| "#{row[:isin]}_plus"; end
      attribute :block_with_column, :key => :name do |row, value| "#{value}_plus"; end

      def custom_method
        'custom'
      end
    end

    before { @list = Xetra.new('spec/files/html/sample.html') }

    subject do
      @list
    end


    its(:document) { should_not be_nil }

    describe :headers do
      subject {@list.headers}

      it { should_not be_empty}
      it { should include(:nameisin) }
      specify { @list.headers[:nameisin].should == 0 }
    end

    describe :results do
      before { @results = @list.to_a }
      subject { @results }

      it { should have(20).items }
#      specify { @results.any?{|r| r[:name] == 'Foo'}.should be_true }
#      specify { @results.first.has_key?(:custom).should be_true }
#      specify { @results.first[:list_of_names].should == '100GBA' }
#      specify { @results.first[:custom].should == 'custom' }
      specify { @results.first[:isin].should == 'FR0010821728' }
      specify { @results.first[:default].should == 'foo' }
#      specify { @results.first[:name_plus_foo].should == 'Foo_plus' }
#      specify { @results.first[:block_with_column].should == 'Foo_plus' }
    end    
  end
end

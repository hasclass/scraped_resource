require 'init'
#require 'lib/scraped_resource'



def check_results(path, klass)
  Dir[path].each do |results_file|
    source_file = results_file.gsub('.yml', '')
    next unless File.exists?(source_file)

    describe results_file do
      before(:all) do
        @spider = klass.list_mapper.new(source_file)
        @arr = @spider.to_a
      end

      specify {@arr.should_not be_nil}

      results = YAML::load_file(results_file) rescue []
      puts path if results.empty?
      results.each_with_index do |result, i|
        it "#{results_file}row #{i} should be the same" do 
          result.each do |key, expected_value|
            next if key == :spidered_at
            # compare string values, otherwise comparing floats with each other sucks
            parsed_value = @arr[i][key]
            if parsed_value.is_a?(Float)
              parsed_value.should be_close(expected_value, 0.0001)
            else
              parsed_value.to_s.should ==(expected_value.to_s) 
            end
          end
        end
      end
    end#describe
  end
end


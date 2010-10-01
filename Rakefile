require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "scraped_resource"
    gem.summary = %Q{Webscraping framework}
    gem.description = %Q{Webscraping framework}
    gem.email = "sebi.burkhard@gmail.com"
    gem.homepage = "http://github.com/hasclass/scraped_resource"
    gem.authors = ["hasclass"]

    gem.add_dependency 'activesupport'
    gem.add_dependency 'fastercsv', '1.5.3'
    gem.add_dependency 'mechanize', '1.0.0'
    gem.add_dependency 'roo', '1.9.3'
    gem.add_dependency 'google-spreadsheet-ruby'
    gem.add_dependency 'rubyzip', '0.9.4'
    gem.add_dependency 'spreadsheet', '0.6.4.1'

    gem.add_development_dependency 'rspec', '1.3.0'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "scraped #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

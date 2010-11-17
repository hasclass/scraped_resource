#--
# Copyright (c) 2010 Sebastian Burkhard
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'rubygems'
#require 'active_support'
require 'activesupport'
require 'mechanize'
# require 'nokogiri' # Nokogiri is included by mechanize
require 'roo'
#require 'fastercsv'

require 'lib/scraped_resource/normalizer/base'
require 'lib/scraped_resource/normalizer/numeric'
require 'lib/scraped_resource/base.rb'
require 'lib/scraped_resource/document.rb'
require 'lib/scraped_resource/row.rb'
require 'lib/scraped_resource/attribute.rb'
require 'lib/scraped_resource/html_table.rb'
require 'lib/scraped_resource/options.rb'
require 'lib/scraped_resource/util.rb'
require 'lib/scraped_resource/version.rb'
require "lib/scraped_resource/csv/base.rb"
require "lib/scraped_resource/csv/config.rb"
require "lib/scraped_resource/csv/list.rb"
require "lib/scraped_resource/excel/base.rb"
require "lib/scraped_resource/excel/config.rb"
require "lib/scraped_resource/excel/list.rb"
require "lib/scraped_resource/html/base.rb"
require "lib/scraped_resource/html/config.rb"
require "lib/scraped_resource/html/list.rb"
require "lib/scraped_resource/remote/agent.rb"
require "lib/scraped_resource/remote/http_resource.rb"
require "lib/scraped_resource/remote/local_file.rb"

module ScrapedResource

end


# roo requires:
#
# gem install rubyzip
# gem install ruby-ole
# gem install google-spreadsheet-ruby 
# gem install spreadsheet

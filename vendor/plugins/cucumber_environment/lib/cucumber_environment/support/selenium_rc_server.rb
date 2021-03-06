require 'webrat'
require 'webrat/selenium'

module Webrat
  module Selenium
    class SeleniumRCServer
      alias old_jar_path jar_path
     
      # use server at ccenv directory
      def jar_path        
        directory = File.expand_path(File.join(__FILE__, "../../../../vendor/selenium_server/*.jar"))
        files = Dir[directory]
        if files.size == 0
          server = old_jar_path
        else 
          server = files.first
        end
        puts "Using selenium server #{server}"
        server
      end
    end
  end
end

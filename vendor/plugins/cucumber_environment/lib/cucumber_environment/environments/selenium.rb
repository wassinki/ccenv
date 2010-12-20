require 'webrat'
require 'webrat/selenium'
require 'webrat/selenium/selenium_session'
require 'webrat/selenium/application_servers/rails'

Webrat.configure do |config|
  config.mode = :selenium  
  config.application_environment = :cucumber
  config.application_framework = :rails  
  config.open_error_files = true # Set to true if you want error pages to pop up in the browser
  # Selenium defaults to using the selenium environment. Use the following to override this.
    
  selenium_browser_key = ENV['selenium.browser_key'] || "*firefox"
  selenium_browser_startup_timeout = 3000
  selenium_server_address = ENV['selenium.server_address'] || "http://localhost"
  selenium_server_port = ENV['selenium.server_port'] || 6666
end

# Selenium server
module Webrat
  module Selenium
    module ApplicationServers            
      class Rails < Webrat::Selenium::ApplicationServers::Base        
        def start_command
          # if selenium is already running, then kill process
          if File.exist?(File.join(rails_root, "tmp", "pids", "mongrel_selenium.pid"))
            stop_command
          end
          
          shell_options = " s --daemon --port=#{Webrat.configuration.application_port} --environment=#{Webrat.configuration.application_environment} &"
          shell_command = File.expand_path(File.join(rails_root, "script", "rails")) + shell_options
          shell_command
        end

        def stop_command
          pid_file = File.expand_path(File.join(rails_root, "tmp", "pids", "server.pid"))
          shell_command = "kill -9 $(cat #{pid_file})"
          shell_command
        end
        
        private
        
        def rails_root
          File.join(File.dirname(__FILE__), (0..5).inject([]){|v,i| v << ".."})
        end
      end
    end
  end
end

# this is necessary to have webrat "wait_for" the response body to be available
# when writing steps that match against the response body returned by selenium
World(Webrat::Selenium::Matchers)


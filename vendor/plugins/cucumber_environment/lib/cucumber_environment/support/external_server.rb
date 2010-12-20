require 'rubygems'
require 'webrat/selenium/application_servers/external'
require 'fileutils'
require 'net/http'

# The external server implementation to start the external environment automatically
module Webrat
  module Selenium
    module ApplicationServers
      class External        
        attr_reader :project_root
        attr_reader :vpu_dir
        attr_reader :data_dir        
       
        
        # starts the server
        def start
          external_command = start_command          
          return if external_command.nil?
          
          puts "Starting external server"
                  
          # Don't start server if this parameter is given
          return false if ENV["NO_EXTERNAL_SERVER"] == "true"
          
          # start the server
          @pid = fork do            
            exec(external_command)            
          end
          
          # wait until connection is available
          request = Net::HTTP::Get.new("/")
          tries = 10             
          begin            
            sleep(5)
            response = Net::HTTP.start(Webrat.configuration.application_address, Webrat.configuration.application_port){|http| http.request(request)}
            raise Exception.new(response.error) unless [Net::HTTPSuccess, Net::HTTPRedirection].any?{|klazz| response.is_a? klazz}
          rescue Exception => e
            tries -= 1
            retry unless tries.zero?
            
            STDERR.puts "Cannot start server: #{e.message}"
            exit
          end   
          
          return true       
        end
        
        # stops the server
        def stop
          unless @pid.nil?
            silence_stream(STDOUT) do            
              Process.kill('KILL', @pid)
              Process.waitpid(@pid)
            end
          end
        end
        
        # fails
        def fail          
          $stderr.puts "\n\n==> Failed to boot the external application server... exiting!\n\n"
          exit
        end
        
        protected                   
        
        # generates the start command        
        def start_command          
          nil
        end        
      end
    end
  end
end


# Before filter to start the server in mechanize environment automatically
Before do
  # only start if server hasn't started yet or mode is selenium (becuase this will automatically start the server)
  unless Webrat::Selenium::ApplicationServerManager.instance.server_started || Webrat.configuration.mode == :selenium  
    Webrat::Selenium::ApplicationServerManager.instance.start_server if Webrat.configuration.application_framework == :external
  end
end

# Shutdown server at the end of all runs
at_exit do
  # always stop server; the manager will now if it needs to stop the server
  Webrat::Selenium::ApplicationServerManager.instance.stop_server  
end

# Velos application server manager to start and to stop the server
module Webrat
  module Selenium
    class ApplicationServerManager  
      attr_accessor :server
      attr_accessor :server_started

      
      # stops the server
      def start_server
        unless @server_started    
          @server_started = @server.start          
        end
      end
      
      # starts the server
      def stop_server
        unless @server.nil? || !@server_started
          @server.stop
          @server_started = false
        end
      end
   
      # class methods
      class << self
        @singleton = nil;
        # returns the singleton
        def instance
          if @singleton.nil?      
            @singleton = Webrat::Selenium::ApplicationServerManager.new        
          end
          @singleton
        end      
      end
      
      private
            
      def initialize
        @server = Webrat::Selenium::ApplicationServers::External.new
        @server_started = false
      end
    end
  end
end

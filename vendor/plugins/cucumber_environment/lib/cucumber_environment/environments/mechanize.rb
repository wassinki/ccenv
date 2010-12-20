require 'webrat'

Webrat.configure do |config|
  config.mode = :mechanize
  config.application_environment = :cucumber
  config.open_error_files = false # Set to true if you want error pages to pop up in the browser
end



module ActionDispatch
  IntegrationTest.class_eval do
    include Rack::Test::Methods
    include Webrat::Methods
    include Webrat::Matchers
  end
end

module SeleniumSessionHelpers     
  DEFAULT_TIMEOUT = 30   
  
  # Method to wait for the elemens
  def wait_for_load(hints = {})
    begin          
      if hints[:url]
       selenium.wait_for_page(DEFAULT_TIMEOUT)
      elsif hints[:link]
        sleep(2)
      end
    rescue Exception => e          
      raise e unless e.message.match /timed\s*out/          
    end      
  end
end
        

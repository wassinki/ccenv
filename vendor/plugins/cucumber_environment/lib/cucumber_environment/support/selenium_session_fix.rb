AfterConfiguration do |config|
  if defined? Webrat::SeleniumSession    
    module Webrat
      class SeleniumSession
        DEFAULT_TIMEOUT = 30

        # try to find field by name
        def field_labeled(field_name)
          v = selenium.get_value field_with_name(field_name)
          def v.value
            self
          end         
          v
        end
        
        # search for input with field name
        def field_with_name(field_name)
          result = input_field_with_name(field_name) || select_with_name(field_name)
        end

        # tries to find the field with given name, using the type selector
        # if no type is given, all input fields are looked for
        def input_field_with_name(field_name, type=nil)
          types = type.nil? ? %w(text password file checkbox radio) : type.to_a
          type_selector = types.map{|f| "@type='#{f}'"}.join(" or ")
          field_by_xpath("//p[./label[starts-with(text(), '#{field_name}')]]//input[#{type_selector}]" )
        end

        # tries to find the select with the given name
        def select_with_name(field_name)
          field_by_xpath("//p[./label[starts-with(text(), '#{field_name}')]]//select" )
        end
              
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
        
        # The method now waits for page load
        alias original_visit visit
        def visit(url)
          original_visit(url)        
          wait_for_load(:url => url)        
        end
        
        # sometims location seems not to be availbe soon,
        # so then wait a second
        alias original_current_url current_url      
        def current_url
          max_tries = 3
          location = original_current_url
          while location.nil? && !max_tries.zero?
            sleep(1)
            location = original_current_url
            max_tries -= 1
          end
          location
        end
        
        alias original_click_link click_link      
        # The method now waits for page load      
        def click_link(link_text_or_regexp, options={})
          begin
            # don't do original click, this one seems to wait for some reasons
            #original_click_link(link_text_or_regexp, options)

            # try to find element with text          
            selenium.click("xpath=//a[descendant-or-self::*[normalize-space(text())='#{link_text_or_regexp}'] ]") 
                      
            # only wait if message is not a confirmation
            wait_for_load(options.merge(:link => link_text_or_regexp)) unless selenium.confirmation?                    
          rescue Exception => e
            raise e unless e.message.match /timed\s*out/
          end      
        end
        
        # Method to get a field by xpath expression
        def field_by_xpath(xpath_expression)
          expression = "xpath=#{xpath_expression}"
          
          return selenium.element?(expression) ? expression :nil
        end
                    
        # Only uses webrat identifier if identifier doesn't start with xpath
        def fill_in(field_identifier, options)   
          locator = field_identifier.starts_with?("xpath=") ? field_identifier : "webrat=#{field_identifier}"
          
          selenium.wait_for_element locator, :timeout_in_seconds => 5
          selenium.type(locator, "#{options[:with]}")
        end
        
        # Only uses webrat identifier if identifier doesn't start with xpath
        def choose(label_text)
          locator = label_text.starts_with?("xpath=") ? label_text : "webrat=#{label_text}"
          
          selenium.wait_for_element locator, :timeout_in_seconds => 5
          selenium.click locator
        end
        
        alias check choose
        
        # Only uses webrat identifier if identifier doesn't start with xpath
        def fire_event(field_identifier, event)
          locator = label_text.starts_with?("xpath=") ? field_identifier : "webrat=#{Regexp.escape(field_identifier)}"
          
          selenium.fire_event(locator, "#{event}")
        end
        
        # Only uses webrat identifier if identifier doesn't start with xpath
        def key_down(field_identifier, key_code)
          locator = label_text.starts_with?("xpath=") ? field_identifier : "webrat=#{Regexp.escape(field_identifier)}"        
          selenium.key_down(locator, key_code)
        end
        
        # Only uses webrat identifier if identifier doesn't start with xpath
        def key_up(field_identifier, key_code)
          locator = label_text.starts_with?("xpath=") ? field_identifier : "webrat=#{Regexp.escape(field_identifier)}"
          selenium.key_up(locator, key_code)
        end  
      end
    end
    
    # removes annoying log messages to stdout
    module Selenium
      module Client
        module Protocol
          def http_post(data)
            start = Time.now
            called_from = caller.detect{|line| line !~ /(selenium-client|vendor|usr\/lib\/ruby|\(eval\))/i}
            http = Net::HTTP.new(@host, @port)
            http.open_timeout = default_timeout_in_seconds
            http.read_timeout = default_timeout_in_seconds
            response = http.post('/selenium-server/driver/', data, HTTP_HEADERS)
            
            [ response.body[0..1], response.body ]
          end     
        end
      end
    end
  end
end

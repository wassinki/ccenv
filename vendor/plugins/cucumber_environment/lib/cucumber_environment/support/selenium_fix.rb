
AfterConfiguration do |config|
  if defined? Selenium::Client::GeneratedDriver
  
    module Selenium::Client::GeneratedDriver
        
    
        # fix for confirm dialog
        def choose_ok_on_next_confirmation
          choose_on_next_confirmation(true)
        end
        
        # fix for confirm dialog
        def choose_cancel_on_next_confirmation
          choose_on_next_confirmation(false)
        end
        
        # fix for confirm dialog
        def choose_on_next_confirmation(value)
          script = <<-END_OF_SCRIPT
            window.confirm = function() {
              document.body.innerHTML += "<div id='selenium_confirm_box' style='background-color: gray; display:none'>" + arguments[0] + "<br/>" + 
              "<button>Cancel #{value}</button>" + "<button>OK</button></div>";
               
              return #{value};
            };
            END_OF_SCRIPT
            
          run_script(script)          
        end
      end
    end
    
    if defined? Selenium::Client::Idiomatic
      module Selenium::Client::Idiomatic
      
        # fix for alert dialog
        def alert
          script = <<-END_OF_SCRIPT
            window.alert = function() {
              document.body.innerHTML += "<div id='selenium_alert_box' style='background-color: gray; display:none'>" + arguments[0] + "<br/>" + 
              "<button>OK</button></div>";
            };
            END_OF_SCRIPT
            
          run_script(script)        
        end
      
        
        # fix for confirm dialog
        def confirmation?
          
        end
        
        # fix for confirm dialog
        def confirmation
          
        end
    end
  end
end
    

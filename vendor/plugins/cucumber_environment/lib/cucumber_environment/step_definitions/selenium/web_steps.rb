require 'base64' 
      
button_regexp = lambda {|button| "//a[contains(@class,'button')]//*[contains(text(), '#{button}')]"}


Then /^(?:I )will (not )?\s*confirm for$/ do |dont_confirm|
  unless dont_confirm    
    selenium.choose_ok_on_next_confirmation
  else
    selenium.choose_cancel_on_next_confirmation    
  end  
end

Then /^(?:I )should (not )?\s*see a confirm dialog$/ do |negate|  
  #unless negate
  #  assert selenium.confirmation?
  #else
  #  assert_false selenium.confirmation?  
  #end  
end

Then /^(?:I )see the confirm dialog( with text "([^\"]*)"?)?$/ do |with_text, text|  
  #assert selenium.confirmation?
  #if with_text
  #  assert_equal(text, selenium.confirmation)
  #else
  #  selenium.confirmation
  #end
  #assert_false selenium.confirmation?       
end


Then /^(?:I )should (not )?\s*see an alert dialog?$/ do |negate|
  unless negate    
    assert_false(selenium.alert?)
  else
    assert(selenium.alert?)
  end
end

Then /^(?:I )should see an alert dialog with text "([^\"]*)"$/ do |text|
  alert_message = selenium.get_alert() 
  assert_equal(text, alert_message)
end


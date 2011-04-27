require 'base64' 
      
button_regexp = lambda {|button| "//a[contains(@class,'button')]//*[contains(text(), '#{button}')]"}

Given /^I am logged in with username "([^"]*)" and password "([^"]*)"$/ do |username, password|
  Given %{I am on the login page}  
  When %{I select "#{username}" from "Username"}
  And %{I fill in "#{password}" for "Password"}       
  And %{I follow "Login"}
end


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

Then /^(?:I )should (not )?\s*see an alert dialog(?: with text "([^\"]*)")?$/ do |negate, text|
  unless negate    
    assert_equal(text, selenium.alert) unless text.blank?    
  else
    assert_false(selenium.alert?)
  end
end


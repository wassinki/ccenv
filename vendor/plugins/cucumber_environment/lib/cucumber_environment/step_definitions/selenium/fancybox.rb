When /^(?:I )close the popup$/ do
  selenium.click("//*[@id='fancybox-close']")  
end

Then /^(?:|I )should (not )?see a popup$/ do |not_visible|
  if not_visible.blank?
    begin
      selenium.wait_for_visible("//*[@id='fancybox-close']", :timeout_in_seconds => 10)
    rescue Exception
    end  
    assert selenium.visible?("//*[@id='fancybox-close']")
  elsif selenium.element?("//*[@id='fancybox-close']") && selenium.visible?("//*[@id='fancybox-close']")
    begin
      selenium.wait_for_not_visible("//*[@id='fancybox-close']", :timeout_in_seconds => 10)
    rescue Exception
    end 
    assert !selenium.visible?("//*[@id='fancybox-close']")
  end
end

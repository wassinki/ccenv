module SeleniumSessionHelpers
  # Method to wait for the elemens
  def wait_for_load(hints = {})
    begin
      if hints[:url]
        selenium.wait_for_page(30)
      elsif hints[:link]
        sleep(2)
      else
        sleep(2)
      end
    rescue Exception => e
      raise e unless e.message.match /timed\s*out/
    end
  end

  # The method now waits for page load
  def click_link_by_href(href, options={})
    begin
      # don't do original click, this one seems to wait for some reasons
      #original_click_link(link_text_or_regexp, options)

      # try to find element with text
      selenium.click("xpath=//a[contains(@href,\"#{href}\")]")

      # only wait if message is not a confirmation
      wait_for_load(options) unless selenium.confirmation?
    rescue Exception => e
      raise e unless e.message.match /timed\s*out/
    end
  end
  
  def click_link_by_class_and_text(classname, text, options={})
    begin
      # don't do original click, this one seems to wait for some reasons
      #original_click_link(link_text_or_regexp, options)

      # try to find element with text
      selenium.click("xpath=//a[descendant-or-self::*[normalize-space(text())=\"#{text}\"][contains(@class,\"#{classname}\")]]") 

      # only wait if message is not a confirmation
      wait_for_load(options) unless selenium.confirmation?
    rescue Exception => e
      raise e unless e.message.match /timed\s*out/
    end
  end
end


# Commonly used webrat steps
# http://github.com/brynary/webrat

Given /^I am on (.+)$/ do |page_name|  
  visit path_to(page_name)
end

When /^I go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^I press "([^\"]*)"$/ do |button|
  click_button(button)
end

When /^I follow "([^\"]*)"$/ do |link|
  click_link(link)  
end

When /^I follow "([^\"]*)" within "([^\"]*)"$/ do |link, parent|
  click_link_within(parent, link)
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  When %{I fill in "#{value}" for "#{field}"}
end

When /^I fill in "([^\"]*)" for "([^\"]*)"$/ do |value, field|
  fill_in(input_field_with_name(field), :with => value)
end




# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^I fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
end

When /^I select "([^\"]*)" (?:from|for) "([^\"]*)"$/ do |value, field|
  select(value, :with => select_with_name(field))
end

When /^I select value "([^\"]*)" (?:from|for) "([^\"]*)"$/ do |value, field|
  select("value=#{value}", :with => select_with_name(field))
end

 

Then /^the field "([^\"]*)" should\s+(not )?\s*have option(?:s)? "([^\"]*)"$/ do |field, not_have, options|
  s = select_with_name(field)
  s["xpath="] = ""

  options.split(/,\s*/).each do |o|
    if not_have.nil?
      assert !field_by_xpath("#{s}/option[text() = '#{o}']").nil?    
    else
      assert field_by_xpath("#{s}/option[text() = '#{o}']").nil?    
    end

  end
end

# Use this step in conjunction with Rail's datetime_select helper. For example:
# When I select "December 25, 2008 10:00" as the date and time
When /^I select "([^\"]*)" as the date and time$/ do |time|
  select_datetime(time)
end

# Use this step when using multiple datetime_select helpers on a page or
# you want to specify which datetime to select. Given the following view:
#   <%= f.label :preferred %><br />
#   <%= f.datetime_select :preferred %>
#   <%= f.label :alternative %><br />
#   <%= f.datetime_select :alternative %>
# The following steps would fill out the form:
# When I select "November 23, 2004 11:20" as the "Preferred" date and time
# And I select "November 25, 2004 10:30" as the "Alternative" date and time
When /^I select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, datetime_label|
  select_datetime(datetime, :from => datetime_label)
end

# Use this step in conjunction with Rail's time_select helper. For example:
# When I select "2:20PM" as the time
# Note: Rail's default time helper provides 24-hour time-- not 12 hour time. Webrat
# will convert the 2:20PM to 14:20 and then select it.
When /^I select "([^\"]*)" as the time$/ do |time|
  select_time(time)
end

# Use this step when using multiple time_select helpers on a page or you want to
# specify the name of the time on the form.  For example:
# When I select "7:30AM" as the "Gym" time
When /^I select "([^\"]*)" as the "([^\"]*)" time$/ do |time, time_label|
  select_time(time, :from => time_label)
end

# Use this step in conjunction with Rail's date_select helper.  For example:
# When I select "February 20, 1981" as the date
When /^I select "([^\"]*)" as the date$/ do |date|
  select_date(date)
end

# Use this step when using multiple date_select helpers on one page or
# you want to specify the name of the date on the form. For example:
# When I select "April 26, 1982" as the "Date of Birth" date
When /^I select "([^\"]*)" as the "([^\"]*)" date$/ do |date, date_label|
  select_date(date, :from => date_label)
end

When /^I check "([^\"]*)"$/ do |field|
  check(input_field_with_name(field))
end

When /^I uncheck "([^\"]*)"$/ do |field|
  uncheck(input_field_with_name(field))
end

When /^I choose "([^\"]*)"$/ do |field|
  choose(input_field_with_name(field))
end

When /^I attach the file at "([^\"]*)" to "([^\"]*)"$/ do |path, field|
  attach_file(field, path)
end

Then /^I should\s+(not )?\s*see the link "([^\"]*)"$/ do |negate, text|  
  if negate.nil?
    assert_false field_by_xpath("//a[text()='#{text}']").nil?
  else
    assert field_by_xpath("//a[text()='#{text}']").nil? 
  end
end

Then /^I should\s+(not )?\s*see "([^\"]*)"$/ do |negate, text|  
  if negate.nil?
    assert_contain text
  else
    assert_not_contain text
  end    
end

Then /^I should\s+(not )?\s*see "([^\"]*)" within "([^\"]*)"$/ do |negate, text, selector|
  within(selector) do |content|
    if negate.nil?
      assert content.include?(text)
    else
      assert_false content.include?(text)
    end
  end
end

Then /^I should\s+(not )?\s*see \/([^\/]*)\/$/ do |negate, regexp|
  regexp = Regexp.new(regexp)
  if negate.nil?
    assert_contain regexp
  else
    assert_not_contain regexp
  end
end

Then /^I should\s+(not )?\s*see \/([^\/]*)\/ within "([^\"]*)"$/ do |negate, regexp, selector|
  within(selector) do |content|
    regexp = Regexp.new(regexp)
    if negate.nil?
      assert content =~ regexp
    else
      assert_false content =~ regexp
    end
  end
end

Then /^I should\s+(not )?\s*see (field|select|textfield|passwordfield|checkbox|radiobutton) "([^\"]*)"$/ do |negate, type, name|
  field = case type
    when "field"
      field_with_name(name)
    when "select"
      select_with_name(name)
    else
      input_field_with_name(name, type)
   end
  
  unless negate
    assert_not_nil field
  else
    assert_nil field
  end
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  assert_match(/#{value}/, field_labeled(field).value)
end

Then /^the "([^\"]*)" field should not contain "([^\"]*)"$/ do |field, value|
  assert_no_match(/#{value}/, field_labeled(field).value)
end

Then /^the "([^\"]*)" (?:checkbox|radio button) should be (checked|unchecked)$/ do |field, checked_unchecked|
  if checked_unchecked == "checked"
    assert field_labeled(field).checked?
  else
    assert !field_labeled(field).checked?
  end
end


Then /^the "([^\"]*)" (checkbox|radio button) should not be (checked|unchecked)$/ do |field, field_type , checked_unchecked|
  checked_unchecked = (checked_unchecked == "checked") ? "unchecked" : "checked"
  Then %(the "#{field}" #{field_type} should be #{checked_unchecked})
end



Then /^the "([^\"]*)" field should be (enabled|disabled)$/ do |field,enabled_disabled|
  if enabled_disabled == "enabled"
    !assert field_labeled(field).disabled?
  else
    assert field_labeled(field).disabled?  
  end
end

Then /^the "([^\"]*)" field should not be (enabled|disabled)$/ do |field,enabled_disabled|
  enabled_disabled = (enabled_disabled == "enabled") ? "disabled" : "enabled"
  Then %(the "#{field}" field should be #{enabled_disabled})
end


Then /^I should( not)? be on (.+)$/ do |negate, page_name|  
  unless negate
    assert_equal URI.parse(path_to(page_name)).path, URI.parse(current_url).path
  else
    assert_not_equal URI.parse(path_to(page_name)).path, URI.parse(current_url).path
  end
end

Then /^show me the page$/ do
  save_and_open_page
end

def field_with_name(field_name)
  result = input_field_with_name(field_name) || select_with_name(field_name)
end

# tries to find the field with given name, using the type selector
# if no type is given, all input fields are looked for
def input_field_with_name(field_name, type=nil)
  types = type.nil? ? %w(text password file checkbox radio) : type.to_a
  type_selector = types.map{|f| "@type='#{f}'"}.join(" or ")
  field_by_xpath("//p[.//label[starts-with(text(), '#{field_name}')]]//input[#{type_selector}]" ) || field_by_xpath("//input[@id='#{field_name}' and (#{type_selector})]" )
end

# tries to find the select with the given name
def select_with_name(field_name)
  field_by_xpath("//p[.//label[starts-with(text(), '#{field_name}')]]//select" )  || field_by_xpath("//select[@id='#{field_name}']" )
end


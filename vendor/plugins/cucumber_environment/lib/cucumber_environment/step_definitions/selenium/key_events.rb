When /^(?:I )type "(.*)" in "(.*)"$/ do |value, field|
  selector = "//p[./label[starts-with(text(), '#{field}')]]//input[@type='text' or @type='password' or @type='file']"
  selenium.type(selector, "")
  value.chars.each_with_index do |char, index|    
    selenium.key_down(selector, char)
    unless char == "."
      selenium.key_press(selector, char)
    else
      # a bug in selenium
      selenium.type(selector, value[0..index])
    end  
    selenium.key_up(selector, char)    
  end
end

When /^(?:I )select "(.+)" for "(.+)"$/ do |value, field|
   selenium.select("//p[./label[starts-with(text(), '#{field}')]]//select", value)
end

When /^(?:I )(un)?check "(.+)"$/ do |uncheck, field|
  if uncheck.blank? && selenium.value("//p[./label[starts-with(text(), '#{field}')]]//input[@type='checkbox']") == "off"
    selenium.key_up("//p[./label[starts-with(text(), '#{field}')]]//input[@type='checkbox']", " ") 
  elsif selenium.value("//p[./label[starts-with(text(), '#{field}')]]//input[@type='checkbox']") == "on"
    selenium.key_up("//p[./label[starts-with(text(), '#{field}')]]//input[@type='checkbox']", " ") 
  end
end


When /^I type in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I type "#{value}" in "#{name}"}
  end
end

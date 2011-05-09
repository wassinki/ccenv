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

When /^I type in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I type "#{value}" in "#{name}"}
  end
end

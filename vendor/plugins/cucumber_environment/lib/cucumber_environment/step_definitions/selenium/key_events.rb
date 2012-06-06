When /^(?:I )type "(.*)" in "(.*)"$/ do |value, field|
  selector = "//p[./label[starts-with(text(), \"#{field}\")]]//input[@type='text' or @type='password' or @type='file']"
  selenium.type(selector, "")
  selenium.type(selector, value)
  selenium.key_down(selector, value[value.length-1].chr)
  selenium.key_up(selector, value[value.length-1].chr)
end

When /^I type in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I type "#{value}" in "#{name}"}
  end
end

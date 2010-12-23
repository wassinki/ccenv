
Given /^I am logged in with username "([^"]*)" and password "([^"]*)"$/ do |username, password|
  basic_auth(username, password) 
end

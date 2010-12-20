Then /^it should be ok$/ do
  assert true
end

Then /^the profile should be (.*)$/ do |profile|
  assert_equal(Webrat.configuration.mode.to_s, profile)
end


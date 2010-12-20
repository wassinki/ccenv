module NavigationHelpers  
  
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to_velos(page_name) 
    case page_name
    when /the google page/
      'http://www.google.nl'
    end    
 end
end

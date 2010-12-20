module NavigationHelpers  
  
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to_for_ccenv(page_name)
    # specify your paths here...
    case page_name
    when /website/
      'http://localhost'
    end    
 end
end

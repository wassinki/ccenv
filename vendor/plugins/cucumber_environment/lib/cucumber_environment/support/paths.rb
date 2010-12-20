require 'uri'

# generates paths
module NavigationHelpers
    
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)    
    path = NavigationHelpers.instance_methods.find_all{|m| m.starts_with?("path_to_")}.map{|m| __send__(m, page_name)}.find{|v| !v.nil?}    

    if path.blank?        
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
    
    # generates an absolute path
    uri = URI.parse(path)
    if uri.relative?
      uri.scheme = "http"
      uri.host = Webrat.configuration.application_address
      uri.port = Webrat.configuration.application_port
    end

    return uri.to_s
  end
  
  # default path mapping
  def path_to_default(page_name)
    case page_name
      
      when /the home\s?page/
      '/'      
    end
    
  end
end
World(NavigationHelpers)

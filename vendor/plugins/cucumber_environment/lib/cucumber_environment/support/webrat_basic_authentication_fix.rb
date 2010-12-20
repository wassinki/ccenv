# sets the basic authentication
require "mechanize"
require "uri"
require "base64"
require 'webrat'
require 'webrat/core/session'

class Mechanize
  alias original_fetch_page fetch_page
  
  def fetch_page(params)
    url = URI.parse(params[:uri])    
    @auth_hash[url.host] = :basic unless @user.nil?    
    original_fetch_page(params)    
  end
end

module Webrat  
  class Session
    def basic_auth(user, pass)
      case adapter
        when Webrat::MechanizeAdapter 
        adapter.mechanize.basic_auth(user, pass)          
      else
        encoded_login = ["#{user}:#{pass}"].pack("m*")
        header('HTTP_AUTHORIZATION', "Basic #{encoded_login}")
      end
    end
  end
end


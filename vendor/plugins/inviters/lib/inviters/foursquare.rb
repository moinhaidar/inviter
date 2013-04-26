require 'page_scraper'
class Inviters
  class Foursquare < PageScraper
    BASE_URL            = "http://foursquare.com/"
    MLOGIN_URL					= "http://foursquare.com/mobile/login"
    LOGIN_URL						= "http://foursquare.com/login"
    INVITE_URL					= "http://foursquare.com/invite"
    PROTOCOL_ERROR      = "Foursquare has changed its protocols, please upgrade this library."
    
    def real_connect
    	create_agent
    	prepare
    end
    
    def prepare
      #Getting Login
    	page = agent.get(LOGIN_URL)
    	raise ConnectionError, PROTOCOL_ERROR if page.nil?
    	raise ConnectionError, PROTOCOL_ERROR unless page.respond_to?('forms')
    	login_form = page.forms[1]
			login_form.fields[0].value = @login
			login_form.fields[1].value = @login
			login_form.fields[2].value = @password
			mainpage = login_form.submit
      if mainpage.body =~ /Invalid Username\/Password/
      	raise AuthenticationError, 'Username and Password do not match!'
      end
      #Getting logout link
      @logout_url = page.link_with(:href => /logout/)
      return true
    end
    
    #Inviting by Email
    def invite(email,  message = nil)
    	success = false
    	if email
	    	page = agent.get(INVITE_URL)
	    	raise AuthenticationError, 'You must login first!' if page.nil? || page.body =~ /Join foursquare to meet up with friends and discover new places!/
	    	raise ConnectionError, PROTOCOL_ERROR unless page.respond_to?('forms')
	    	invite_form = page.forms[1]
				invite_form.fields[0].value = email
	    	resp = invite_form.submit
	    	return true if resp.code == '200'
    	end
    	return success
    end
    
    def logout
    	agent.click @logout_url if @logout_url
      return true
    end
    
  end

  TYPES[:foursquare] = Foursquare
end
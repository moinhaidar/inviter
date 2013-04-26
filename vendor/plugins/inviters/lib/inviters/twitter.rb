require 'page_scraper'
class Inviters
  class Twitter < PageScraper
    BASE_URL            = "https://twitter.com"
    LOGIN_URL						= "http://twitter.com/login"
    INVITE_URL					= "https://twitter.com/invitations/invite_by_email"
    PROTOCOL_ERROR      = "Twitter has changed its protocols, please upgrade this library."
    
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
      login_form.fields[2].value = @login
      login_form.fields[3].value = @password
      mainpage = agent.submit(login_form, login_form.buttons.first)
      
      if mainpage.body =~ /Wrong Username\/Email and password combination/
      	raise AuthenticationError, 'Username and Password do not match!'
      end
      
      @logout_url = page.link_with(:href => /\/logout/)
      return true
    end
    
    #Inviting by Email
    def invite(email,message = nil)
    	success = false
    	if email
	    	page = agent.get(INVITE_URL)
	    	raise AuthenticationError, 'You must login first!' if page.body =~ /Sign in to Twitter/
	    	invite_form = page.forms[1]
	    	unless invite_form
	    		raise ConnectionError, PROTOCOL_ERROR
	    		return false
	    	end
	    	invite_form.addresses = email
	    	resp = invite_form.submit
	    	return true if resp.code == '200'
    	end
    	return success
    end
    
    #Logging Out
    def logout
    	page = agent.click @logout_url if @logout_url
	    logout_form = page.forms.first 
	    logout_form.submit
    	return true
    end
   
  end

  TYPES[:twitter] = Twitter
end
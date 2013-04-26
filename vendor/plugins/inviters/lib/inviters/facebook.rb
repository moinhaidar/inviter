require 'page_scraper'
class Inviters
  class Facebook < PageScraper
    BASE_URL            = "http://www.facebook.com/"
    LOGIN_URL						= "https://login.facebook.com/login.php"
    INVITE_URL					= "http://www.facebook.com/friends/?filter=ifp"
    PROTOCOL_ERROR      = "Facebook has changed its protocols, please upgrade this library."
    
    def real_connect
    	create_agent
    	prepare
    end
    
    def prepare
    	#Getting Login
    	page = agent.get(LOGIN_URL)
    	raise ConnectionError, PROTOCOL_ERROR if page.nil?
    	raise ConnectionError, PROTOCOL_ERROR unless page.respond_to?('forms')
      login_form = page.forms.first
    	login_form.email = @login
    	login_form.pass = @password
    	resp = login_form.submit
    	raise AuthenticationError, "Incorrect email!" if resp.body =~ /Incorrect email/
    	raise AuthenticationError, "Incorrect password!" if resp.body =~ /Please re-enter your password/
    	raise AuthenticationError, "Incorrect Email & Password Combination!" if resp.body =~ /Incorrect Email\/Password Combination/
    	
	    @logout_url = page.link_with(:href => /logout/)
    	return true
    end
    
    def invite(email, message = nil)
    	success = false
    	if email
	    	page = agent.get(INVITE_URL)
	    	raise AuthenticationError, "You must login first!" if page.body =~ /You must log in to see this page/
	    	
	    	page.forms.each do |f|
	    		if f.has_field?('email_list')
	    			f.email_list = email
	    			f.personal = message if message && !message.empty?
	    			resp = f.submit
	    			return true if resp.code == '200' && (resp.body =~ /email addresses you entered has already been invited by you/ || resp.body =~ /Success! You sent/)
	    		end
	    	end
	    	
    	end
    	return success
    end
    
     def logout
     	agent.click @logout_url if @logout_url
      return true
    end
    
  end

  TYPES[:facebook] = Facebook
end
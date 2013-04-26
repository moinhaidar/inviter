require 'page_scraper'
class Inviters
  class Linkedin < PageScraper
    BASE_URL            = "http://m.linkedin.com"
    LOGIN_URL						= "http://m.linkedin.com/session/new"    
    PROTOCOL_ERROR      = "LinkedIn has changed its protocols, please upgrade this library."
    
    def real_connect
    	create_agent
    	prepare
    end
    
    def prepare
      #Getting Login
    	page = agent.get(LOGIN_URL)
    	raise ConnectionError, PROTOCOL_ERROR if page.nil?
    	raise ConnectionError, PROTOCOL_ERROR unless page.respond_to?('forms')
    	login_form = page.forms[0]
      login_form.login = @login
      login_form.password = @password
      mainpage = login_form.submit
      if mainpage.body =~ /Incorrect username or password/
      	raise AuthenticationError, 'Username and Password do not match!'
      end
      #Getting invite links
      invite_link = mainpage.root.search("//a[@id='accesskey_invite']").first
      raise ConnectionError, PROTOCOL_ERROR if invite_link.nil?
      @invite_url = invite_link.attributes['href']
      @logout_url = page.link_with(:href => /session\/logout/)
      return true
    end
    
    #Inviting by Email
    def invite(email,  message = nil)
    	success = false
    	if email
	    	page = agent.get(BASE_URL + @invite_url.to_s)
	    	raise AuthenticationError, 'You must login first!' if page.nil? || page.body =~ /Incorrect username or password/
	    	raise ConnectionError, PROTOCOL_ERROR unless page.respond_to?('forms')
	    	invite_form = page.forms.first
	    	
	    	invite_form.field_with(:name => /email/).value = email
	    	invite_form.field_with(:name => /body/).value = message if message && !message.empty?
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

  TYPES[:linkedin] = Linkedin
end
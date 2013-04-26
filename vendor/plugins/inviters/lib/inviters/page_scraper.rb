# A base class for importers that uses mechanize
require 'mechanize'
class Inviters
	class PageScraper < Base
	
	  attr_accessor :agent
	  
	  # creates the Mechanize agent used to do the scraping 
	  def create_agent
	    self.agent = WWW::Mechanize.new
	    agent.keep_alive = false
	    agent
	  end
	  
	  # Logging in
	  def prepare; end # stub
	
	end
end
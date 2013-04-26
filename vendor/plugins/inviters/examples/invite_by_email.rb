require File.dirname(__FILE__)+"/../lib/inviters"

login = ARGV[0]
password = ARGV[1]

Inviters::Twitter.new(login, password).invite('moinhaidar@gmail.com')
#HOTINK_SETTINGS = Settings.new(:hotink)

#production cred - THIS IS THE HOTINK-PUBLISHER MAIN THEOREM INSTANCE PRODUCION CRED
#OAUTH_CREDENTIALS = { :token => "4iL4tnqIuL8sv2RHQOjQ", :secret => "WSNAza5TIaK7CKggJfSo5cY4MO9xUH7SFItB6gxxE", :site => "http://hotink.theorem.ca"  }

# Chris D's Macbook Pro cred
#OAUTH_CREDENTIALS = { :token => "sh2W3WFO4PWYz8FvBO8g", :secret => "Q2BskVRYyhv5tAEPaevpAav90LRZQ61VpvyId0opI", :site => "http://hotink.theorem.ca" }
# Chris D's Macbook Pro local Hot Ink instance cred
#OAUTH_CREDENTIALS = { :token => "Ox561thufVrAdMDLOeM2YQ", :secret => "uhXUK2XaCOPEraG3wrvc2JjffyIujr6iQjno6i8Q", :site => "http://0.0.0.0:3000" }
# Chris D's office iMac dev cred
#OAUTH_CREDENTIALS = { :token => "HdLS8aGol4BKblPnR8xNA", :secret => "mVMjBHaCZd4bztcN5ANjFdqm10G94Ia529eK3Q2Lc", :site => "http://hotink.theorem.ca"  }

ActiveSupport::XmlMini.backend='Nokogiri'

HOTINK_SETTINGS = { :site => "http://hotink.theorem.ca" }
class Template < ActiveRecord::Base
  belongs_to :account
  belongs_to :design
  
  def code=(template_liquid_code)  
    parsed_template = Marshal.dump( Liquid::Template.parse(template_liquid_code) )
    self.parsed_code = parsed_template
    self.code=template_liquid_code 
  end
  
  def parsed_code
    @parsed_code ||= Marshal.load( self.read_attribute('parsed_code') )
  end
  
end
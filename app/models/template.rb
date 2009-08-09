class Template < ActiveRecord::Base
  belongs_to :account
  belongs_to :design
  
  before_save :parse_code
  
  def parsed_code
    @parsed_code ||= Marshal.load( read_attribute("parsed_code") )    
  end
  
  private
  
  def parse_code
    self.parsed_code = Marshal.dump( Liquid::Template.parse(code) )
  end
  
end
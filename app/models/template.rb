class Template < ActiveRecord::Base
  belongs_to :account
  belongs_to :design
  
  before_save :parse_code
  
  def parsed_code
    data = read_attribute("parsed_code")
    @parsed_code ||= Marshal.load( data )    
  end
  
  private
  
  def parse_code
    parsed_template = Liquid::Template.parse(code)
    write_attribute("parsed_code", Marshal.dump( parsed_template) )
  end
  
end
class Template < ActiveRecord::Base
  belongs_to :account
  belongs_to :design
  
  acts_as_versioned
  
  def name
    return read_attribute('name') unless read_attribute('name').blank?
    "(Unnamed template)"
  end
  
  # You gotta parse in the controller. Here to save you have to...serialize.
  #serialize :parsed_code, Liquid::Template
  def parsed_code=(parsed_liquid_template)
    write_attribute(:parsed_code, Marshal::dump(parsed_liquid_template))
  end
  
  def parsed_code
    @parsed_code ||= Marshal::load( read_attribute(:parsed_code) )
  end
end
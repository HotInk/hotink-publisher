class Template < ActiveRecord::Base
  belongs_to :account
  belongs_to :design
  
  # You gotta parse in the controller. Here to save you have to...serialize.
  def parsed_code=(parsed_template)
    write_attribute(:parsed_code, Marshal.dump(parsed_template))
  end
  def parsed_code
    Marshal.load(read_attribute(:parsed_code))
  end
  
end
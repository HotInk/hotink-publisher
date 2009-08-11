class Template < ActiveRecord::Base
  belongs_to :account
  belongs_to :design
  
  # You gotta parse in the controller. Here to save you have to...serialize.
  serialize :parsed_code, Liquid::Template
  
end
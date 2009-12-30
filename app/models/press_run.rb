class PressRun < ActiveRecord::Base
  belongs_to :account
  validates_presence_of :account
  
  belongs_to :front_page
  validates_presence_of :front_page
  
end

class PressRun < ActiveRecord::Base
  belongs_to :account
  belongs_to :front_page
  
  validate_associated :account
  validates_associated :front_page if self.front_page
end

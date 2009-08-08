class PressRun < ActiveRecord::Base
  belongs_to :account
  belongs_to :front_page
  
end

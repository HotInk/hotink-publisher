class FrontPage < ActiveRecord::Base
  belongs_to :account
  belongs_to :template
  belongs_to :design
  
  has_many :press_runs
  
  validates_presence_of :account
  validates_presence_of :template
  validates_presence_of :design
  
  validates_associated :account
  validates_associated :template
  validates_associated :design
  
end

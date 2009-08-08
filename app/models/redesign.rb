class Redesign < ActiveRecord::Base
  belongs_to :account
  belongs_to :design
  
  validate_associated :account
  validates_associated :design if self.design
end

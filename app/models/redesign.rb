class Redesign < ActiveRecord::Base
  belongs_to :account
  validates_presence_of :account

  belongs_to :design
  validates_presence_of :design
end

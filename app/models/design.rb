class Design < ActiveRecord::Base
  belongs_to :account

  has_many :redesigns
  has_many :templates, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :account_id
end

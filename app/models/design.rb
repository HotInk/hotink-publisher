class Design < ActiveRecord::Base
  belongs_to :account

  has_many :redesigns
  has_many :templates, :dependent => :destroy
end

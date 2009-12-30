class Widget < ActiveRecord::Base
  belongs_to :account
  belongs_to :design
  belongs_to :template 

  has_many :widget_placements, :dependent => :destroy
  has_many :templates, :through => :widget_placements

  serialize :schema
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :design_id
end

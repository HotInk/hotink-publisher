class Design < ActiveRecord::Base
  belongs_to :account

  belongs_to :default_layout, :foreign_key => "layout_id", :class_name => "Layout"
  belongs_to :default_front_page_template, :class_name => "FrontPageTemplate"
  
  has_many :redesigns
  has_many :templates, :dependent => :destroy
  has_many :layouts
  has_many :page_templates
  has_many :front_page_templates
  has_many :partial_templates
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :account_id
end

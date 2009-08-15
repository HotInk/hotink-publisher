class Design < ActiveRecord::Base
  
  belongs_to :account

  belongs_to :default_layout, :foreign_key => "layout_id", :class_name => "Layout"
  belongs_to :default_front_page_template, :class_name => "FrontPageTemplate"
  
  has_many :redesigns
  
  has_many :templates, :conditions => { :active => true }, :dependent => :destroy
  has_many :layouts, :conditions => { :active => true }
  has_many :page_templates,  :conditions => { :active => true }
  has_many :front_page_templates, :conditions => { :active => true }
  has_many :partial_templates, :conditions => { :active => true }
  
  has_many :template_files, :conditions => { :active => true }, :dependent => :destroy
  has_many :javascript_files, :conditions => { :active => true }
  has_many :stylesheets, :conditions => { :active => true }
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :account_id
  
  acts_as_versioned
  
end

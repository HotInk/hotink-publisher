require 'ftools'

class Design < ActiveRecord::Base
  
  after_create :create_filesystem_directories
  
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
  
  def javascript_files_root
    "#{design_root}/javascripts/"
  end
  
  def stylesheets_root
    "#{design_root}/stylesheets/"
  end
  
  def template_media_root
    "#{design_root}/media/"
  end
  
  # Returns a list of the design's javascript files 
  def javascript_files
    begin
      entries = Dir.entries("#{design_root}/javascripts")
      entries.reject { |f| f=="."||f==".." }
    rescue
      []
    end
  end
  
  # Returns a list of the design's stylesheets 
  def stylesheets
    begin 
      entries = Dir.entries("#{design_root}/stylesheets")
      entries.reject { |f| f=="."||f==".." }
    rescue
      []
    end   
  end
  
  def template_media
    begin
      entries = Dir.entries("#{design_root}/media")
      entries.reject { |f| f=="."||f==".." }
    rescue
      []
    end
  end
  
  private
  
  def create_filesystem_directories
    File.makedirs "#{design_root}/media", "#{design_root}/stylesheets", "#{design_root}/javascripts"
  end
  
  def design_root
    "#{RAILS_ROOT}/public/system/#{self.account.name}/#{self.id}"
  end
  
end

class TemplateFile < ActiveRecord::Base
  belongs_to :design
  
  has_attached_file :file, :path => ":rails_root/public/system/:account/:design/media/:version/:filename", :url => "/system/:account/:design/media/:version/:filename", :keep_old_files => :version_condition_met?

  acts_as_versioned
  
  def file_name
    file_file_name
  end
  
  def file_size
    file_file_size
  end
  
  def url
    self.file.url
  end

  def to_liquid(options = {})
    Liquid::TemplateFileDrop.new self, options
  end
  
  def version_condition_met?  
    true
  end
  
end

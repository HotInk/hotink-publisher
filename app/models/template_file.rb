class TemplateFile < ActiveRecord::Base
  belongs_to :design
  
  has_attached_file :file, :path => ":rails_root/public/system/:account/:design/media/:filename", :url => "/system/:account/:design/media/:filename"

  def file_name
    file_file_name
  end
  
  def file_size
    file_file_size
  end
  
end

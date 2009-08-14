class Stylesheet < TemplateFile
  has_attached_file :file, :path => ":rails_root/public/system/:account/:design/stylesheets/:filename", :url => "/system/:account/:design/stylesheets/:filename"

end
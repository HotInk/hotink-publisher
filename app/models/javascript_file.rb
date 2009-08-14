class JavascriptFile < TemplateFile
  
  has_attached_file :file, :path => ":rails_root/public/system/:account/:design/javascripts/:filename", :url => "/system/:account/:design/javascripts/:filename"
end
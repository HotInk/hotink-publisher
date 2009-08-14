class JavascriptFile < TemplateFile
  
  has_attached_file :file, :path => ":rails_root/public/system/:account/:design/javascripts/:version/:filename", :url => "/system/:account/:design/javascripts/:version/:filename", :keep_old_files => :version_condition_met?
end
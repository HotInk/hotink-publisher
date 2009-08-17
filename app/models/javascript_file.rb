class JavascriptFile < TemplateFile
  
  has_attached_file :file, :path => ":rails_root/public/system/:account/:design/javascripts/:version/:basename.:extension", :url => "/system/:account/:design/javascripts/:version/:basename.:extension", :keep_old_files => :version_condition_met?
end
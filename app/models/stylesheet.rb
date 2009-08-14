class Stylesheet < TemplateFile
  has_attached_file :file, :path => ":rails_root/public/system/:account/:design/stylesheets/:version/:filename", :url => "/system/:account/:design/stylesheets/:version/:filename", :keep_old_files => :version_condition_met?

end
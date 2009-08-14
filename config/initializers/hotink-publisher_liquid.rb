
# Register our custom filter
Liquid::Template.register_filter Liquid::HotinkFilters
Liquid::Template.register_filter Liquid::UrlFilters
Liquid::Template.register_filter Liquid::DesignFilters

# the first value of root will be overwritten by ApplicationController
#Liquid::Template.file_system = Liquid::LocalFileSystem.new("#{RAILS_ROOT}/themes/")


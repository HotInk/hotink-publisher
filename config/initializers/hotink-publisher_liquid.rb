
# Register our custom filter
Liquid::Template.register_filter Liquid::HotinkFilters
Liquid::Template.register_filter Liquid::UrlFilters
Liquid::Template.register_filter Liquid::PaginationFilters
Liquid::Template.register_filter Liquid::DesignFilters

# Liquid::Template.Register_Tag Liquid::Commentform

# the first value of root will be overwritten by ApplicationController
#Liquid::Template.file_system = Liquid::LocalFileSystem.new("#{RAILS_ROOT}/themes/")


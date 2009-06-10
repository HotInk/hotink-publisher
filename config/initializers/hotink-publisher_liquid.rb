
# Register our custom filter
Liquid::Template.register_filter Liquid::HotinkFilters

# the first value of root will be overwritten by ApplicationController
Liquid::Template.file_system = Liquid::LocalFileSystem.new("#{RAILS_ROOT}/themes/")

Liquid::Template.register_tag( 'themeitem', Liquid::Themeitem )
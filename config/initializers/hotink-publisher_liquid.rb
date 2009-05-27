
# Register our custom filter
Liquid::Template.register_filter Liquid::HotinkFilters

Liquid::Template.file_system = Liquid::LocalFileSystem.new("#{RAILS_ROOT}/themes/:account_name/views")
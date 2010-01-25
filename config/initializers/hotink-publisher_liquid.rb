require 'liquid/widget'
require 'liquid/include'
require 'liquid/comment'
require 'liquid/comment_form'

Liquid::Template.register_filter Liquid::HotinkFilters  
Liquid::Template.register_tag('include', Liquid::Include)
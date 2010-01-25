require 'liquid/widget'
require 'liquid/include'
require 'liquid/comment'
require 'liquid/comment_form'
require 'liquid/design_filters'
require 'liquid/hotink_filters'
require 'liquid/pagination_filters'
require 'liquid/url_filters'
require 'liquid/clean_truncate_filters'

Liquid::Template.register_tag('include', Liquid::Include)
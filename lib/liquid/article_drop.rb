class Liquid::ArticleDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :title << :subtitle << :section << :published_at

  def initialize(source, options = {})
    super source
    @options  = options
    @liquid.update \
      'bodytext' => @source.bodytext
  end
  
  def authors_list
    source.authors_list
  end
  
end
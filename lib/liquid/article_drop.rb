class Liquid::ArticleDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :title << :subtitle << :published_at << :id

  def initialize(source, options = {})
    super source
    @options  = options
    @liquid.update \
      'bodytext' => @source.bodytext
  end
  
  def authors_list
    source.authors_list
  end
  
  def section
    source.attributes['section']
  end
  
  def account_id
    source.account_id
  end
  
  def id
    source.id
  end
  
  def url
    source.url
  end
  
  def images
    source.images.collect{|image| "http://hotink.theorem.ca/" + image}
  end
  
end
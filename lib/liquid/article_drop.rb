class Liquid::ArticleDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :title << :subtitle  << :id

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
  
  def published_at
    Time.parse(source.published_at).to_s(:standard)
  end
  
  def published_at_detailed
    Time.parse(source.published_at).to_s(:long)
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
  
  def mediafiles
    source.mediafiles
  end

  
end
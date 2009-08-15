class Liquid::MediafileDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :title << :caption  << :date << :authors_list

  def initialize(source, options = {})
    super source
    @options  = options
  end
  
  #TODO: figure out a nicer way of doing this other than enumerating the sizes
  def image_url_original
    source.image_url("original")
  end
  
  def image_url_thumb
    source.image_url("thumb")
  end
  
  def image_url_small
    source.image_url("small")
  end
  
  def image_url_medium
    source.image_url("medium")
  end      
  
  def image_url_large
    source.image_url("large")
  end
  
  def image_url_system_default
    source.image_url("system_default")
  end

  def image_url_system_thumb
    source.image_url("system_thumb")
  end     
  
  def image_url_system_icon
    source.image_url("system_icon")
  end   
  
end
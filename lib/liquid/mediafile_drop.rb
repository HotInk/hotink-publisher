class Liquid::MediafileDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  
  liquid_attributes << :title << :caption  << :date << :mediafile_type

  def initialize(source, options = {})
    super source
    @options  = options
  end
  
  # General data
  def id
    source.id
  end
  
  def authors_list
    source.authors_list
  end
  
  def image?
    source.mediafile_type == "Image"
  end
  
  def audiofile?
    source.mediafile_type == "Audiofile"
  end
  
  def file?
    source.mediafile_type == "Mediafile"
  end
  # Mediafile-specific
  
  def url
    if source.mediafile_type == "Image"
      source.url.original
    else
      source.url
    end
  end
  
  def file_size
    source.original_file_size
  end
  
  # Image specific
    
  def is_vertical?
    source.height.to_i > source.width.to_i
  end
  
  def is_horizontal?
    source.height.to_i <= source.width.to_i
  end
  
  def height
    if source.height
      return source.height.to_i
    else
      0
    end
  end
  
  def width
    if source.width
      return source.width.to_i
    else
      0
    end
  end
  
  def original_url
     source.url.original
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
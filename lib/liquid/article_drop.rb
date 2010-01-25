class Liquid::ArticleDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  include Liquid::UrlFilters
  include Liquid::StandardFilters
    
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :title << :subtitle

  def initialize(source, options = {})
    super source
    @options  = options
    @liquid.update \
      'bodytext' => @source.bodytext.nil? ? "" : @source.bodytext
  end
  
  def section
    if source.attributes['section'].nil?
      nil
    else
      URI.decode(source.attributes['section'])
    end
  end
  
  def word_count
    source.word_count
  end
  
  # Article date methods
  def published_at
    Time.parse(source.published_at).to_s(:standard).gsub(' ', '&nbsp;')
  end
  
  def published_at_detailed
    Time.parse(source.published_at).to_s(:long)
  end
  
  def updated_at
    Time.parse(source.updated_at).to_s(:standard).gsub(' ', '&nbsp;')
  end
  
  def updated_at_detailed
    Time.parse(source.updated_at).to_s(:long)
  end
  
  # Article data 
  def account_id
    source.account_id
  end
  
  def id
    source.id
  end
  
  def url
    source.url
  end
  
  ## Mediafiles ##
  
  def attached_media
    source.mediafiles
  end
  
  # This method is deprecated. Use ArticleDrop#attached_media instead
  def mediafiles
    source.mediafiles
  end
  
  def files
    source.mediafiles.select{ |a| a.mediafile_type == "Mediafile" }
  end
  
  def images
    source.mediafiles.select{ |a| a.mediafile_type == "Image" }
  end
  
  def has_image?
    if source.images.detect{|i| i }
      return true
    else
      return false
    end
  end

  def has_vertical_image?
    if source.images.detect { |image| image.height.to_i > image.width.to_i }
      return true
    else
      return false
    end
  end

  def has_horizontal_image?
    if source.images.detect { |image| image.height.to_i <= image.width.to_i }
      return true
    else
      return false
    end
  end
  
  def first_vertical_image
    source.images.detect { |image| image.height.to_i > image.width.to_i }
  end
  
  def first_horizontal_image
    source.images.detect { |image| image.height.to_i <= image.width.to_i }
  end
  
  def audiofiles
    source.mediafiles.select{ |a| a.mediafile_type == "Audiofile" }
  end
  
  def has_audiofile?
    if audiofiles.detect {|a| a }
      return true
    else
      return false
    end
  end
  
  ## Tags ##
  
  def tags
    source.tags
  end
  
  def tags_list
    case source.tags.length
     when 0
       return nil
     when 1
       return source.tags.first.blank? ? "" : source.tags.first.name
     else
       tags_list = source.tags.collect{ |t| t.name }
       tags_list.join(', ')
    end  
  end
  
  def tags_list_with_links  
    case source.tags.length
     when 0
       return nil
     when 1
       return source.tags.first.blank? ? "" : link_to_tag(source.tags.first)
     else
      tags_list = source.tags.collect{ |t| link_to_tag(t) }
      tags_list.join(', ')
    end
  end
  
  def categories
    source.categories
  end
  
  def blogs
    source.blogs
  end
  
  def issues
     source.issues
  end
  
  # Authors and lists
  def authors
    source.authors
  end
  
  def authors_list
    if source.authors_list.blank?
      nil
    else
      source.authors_list
    end
  end
  
  # Returns list of article's author names as a readable list, separated by commas and the word "and".
  def authors_list_with_links
     case source.authors.length
     when 0
       return nil
     when 1
       return source.authors.first.blank? ? "" : link_to_author(source.authors.first)
     when 2
      #Catch cases where the second author is actually an editorial title, this is weirdly common.
      if source.authors.second.name =~ / editor| Editor| writer| Writer|Columnist/
        return link_to_author(source.authors.first)+ " - " + source.authors.second.name
      else
        return link_to_author(source.authors.first) + " and " + link_to_author(source.authors.second)
      end
     else
      list = String.new
      (0..(source.authors.length - 3)).each{ |i| list += link_to_author(source.authors[i]) + ", " }
      list += link_to_author(source.authors[source.authors.length-2]) + " and " + link_to_author(source.authors[source.authors.length-1]) # last two authors get special formatting
      return list
    end         
  end
  
  def excerpt
    if source.summary.blank?
      truncatewords(source.bodytext, 120)
    else
      source.summary
    end
  end
  
  def comments
    source.comments
  end  
  
  def comment_count
    return source.comments.length.to_i.to_s
  end
  
  # default: unlocked. TODO: put this into an account configuration option
  def comments_locked
    option = source.article_option
    if option.comments_locked == nil
      false
    else
      option.comments_locked
    end
  end

  # default: enabled. TODO: put this into an account configuration option  
  def comments_enabled
    option = source.article_option
    if option.comments_enabled == nil
      true
    else
      option.comments_enabled
    end
  end 
  
  def article_option_id
    if source.article_option.nil?
      "nil"
    elsif source.article_option.new_record?
      "new record"
    else
      source.article_option.id 
    end 
  end
end
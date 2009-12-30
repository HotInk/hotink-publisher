class Liquid::ArticleDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  include Liquid::UrlFilters
    
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
  
  # Mediafiles
  
  def mediafiles
    source.mediafiles
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

  def has_horizontal_image?
    if source.images.detect { |image| image.height.to_i <= image.width.to_i }
      return true
    else
      return false
    end
  end
  
  def first_horizontal_image
    source.images.detect { |image| image.height.to_i <= image.width.to_i }
  end
  
  def has_vertical_image?
    if source.images.detect { |image| image.height.to_i > image.width.to_i }
      return true
    else
      return false
    end
  end
  
  def first_vertical_image
    source.images.detect { |image| image.height.to_i > image.width.to_i }
  end
  
  def audiofiles
    source.audiofiles
  end
  
  def has_audiofile?
    if source.audiofiles.detect {|a| a }
      return true
    else
      return false
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
  
  # Tags and lists
  def tags
    source.tags
  end
  
  def tags_list
    case source.tags.length
     when 0
       return nil
     when 1
       return source.tags.first.blank? ? "" : source.tags.first.name
     when 2
        return source.tags.first.name + ", " + source.tags.second.name
     else
      list = String.new
      (0..(source.tags.count - 3)).each{ |i| list += source.tags[i].name + ", " }
      list += source.tags[source.tags.length-2].name + ", " + source.tags[source.tags.length-1].name # last two authors get special formatting
      return list
    end  end
  
  def tags_list_with_links  
    case source.tags.length
     when 0
       return nil
     when 1
       return source.tags.first.blank? ? "" : link_to_tag(source.tags.first)
     when 2
        return link_to_tag(source.tags.first) + ", " + link_to_tag(source.tags.second)
     else
      list = String.new
      (0..(source.tags.length - 3)).each{ |i| list += link_to_tag(source.tags[i]) + ", " }
      list += link_to_tag(source.tags[source.tags.length-2]) + ", " + link_to_tag(source.tags[source.tags.length-1]) # last two authors get special formatting
      return list
    end
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
    if source.summary
      source.summary
    else
      words = 120
      if source.bodytext.nil? then return end
      wordlist = source.bodytext.split
      l = words.to_i - 1
      l = 0 if l < 0
      wordlist.length > l ? wordlist[0..l].join(" ") + "..." : source.bodytext
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
    begin
      account = Account.find_by_account_resource_id(source.account_id)
      account.article_options.find_by_article_id(source.id).comments_locked
    rescue
      false      
    end
  end

  # default: enabled. TODO: put this into an account configuration option  
  def comments_enabled
    begin
      account = Account.find_by_account_resource_id(source.account_id)
      account.article_options.find_by_article_id(source.id).comments_enabled
    rescue
      true
    end
  end 
  
end
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
  
  def section
    URI.decode(source.attributes['section'])
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
  
  def images
    source.images
  end
  
  def audiofiles
    source.audiofiles
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
    "I got your list right here."
  end
  
  # Authors and lists
  def authors
    source.authors
  end
  
  def authors_list
    source.authors_list
  end
  
  # Returns list of article's author names as a readable list, separated by commas and the word "and".
  def authors_list_with_links
     case self.authors.length
     when 0
       return nil
     when 1
       return self.authors.first.blank? ? "" : self.authors.first.name
     when 2
      #Catch cases where the second author is actually an editorial title, this is weirdly common.
      if self.authors.second.name =~ / editor| Editor| writer| Writer| Columnist/
        return self.authors.first.name + " - " + self.authors.second.name
      else
        return self.authors.first.name + " and " + self.authors.second.name
      end
     else
      list = String.new
      (0..(self.authors.count - 3)).each{ |i| list += authors[i].name + ", " }
      list += authors[self.authors.length-2].name + " and " + authors[self.authors.length-1].name # last two authors get special formatting
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
  
end
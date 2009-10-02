class Entry < HyperactiveResource

  belongs_to :blog, :nested => true

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
    @article_drop ||= Liquid::ArticleDrop.new self, options
  end
  
  def images
    self.mediafiles.select{|mediafile| mediafile.mediafile_type == "Image"}
  end

  def audiofiles
    self.mediafiles.select{|mediafile| mediafile.mediafile_type == "Audiofiles"}
  end
  
  def blog_id
    self.prefix_options[:blog_id]
  end

end
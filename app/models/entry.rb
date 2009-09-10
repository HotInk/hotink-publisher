class Entry < HyperactiveResource

  belongs_to :blog, :nested => true

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
    {'title' => self.title, 'bodytext' => self.bodytext, 'id' => self.id, 'blog_id' => self.blog_id}
  end
  
  def blog_id
    self.prefix_options[:blog_id]
  end

end
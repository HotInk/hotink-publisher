class Article < HyperactiveResource

  self.prefix = "/accounts/:account_id/"

  belongs_to :account, :nested => true

  has_many :sections
  has_many :mediafiles
  has_many :authors

  def comments
    Comment.find_all_by_content_id(self.id)
  end
  
  def to_liquid(options = {})
   @article_drop ||= Liquid::ArticleDrop.new self, options
  end

  def article_options
    ArticleOptions.find_by_article_id_and_account_id(self.id, self.prefix_options[:account_id])
  end
  
  def images
    self.mediafiles.select{|mediafile| mediafile.mediafile_type == "Image"}
  end

  def audiofiles
    self.mediafiles.select{|mediafile| mediafile.mediafile_type == "Audiofiles"}
  end
  
  def account_id
    self.prefix_options[:account_id]
  end
  
  def url
    @account = Account.find(account_id)
    url = @account.url + "/articles/" + self.id.to_s
  end
  
  #Define class for api child categories
  class Category < Section
    class Child < Category
    end
  end
  
end

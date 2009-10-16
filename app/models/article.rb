class Article < HyperactiveResource

  self.prefix = "/accounts/:account_id/"

  belongs_to :account, :nested => true

  has_many :sections
  has_many :mediafiles
  has_many :authors

  def self.find_and_key_by_id(options={})
    # One request to find them all
    article_resources = Article.find(:all, options)
    articles_keyed_by_id = {}
    # Recontruct fetched articles as hash keyed by article id
    article_resources.each do |article|
      articles_keyed_by_id.merge!(article.id.to_s => article)
    end
    articles_keyed_by_id
  end

  def comments
    conditions = {}
    Comment.find_all_by_content_id(self.id, :conditions => conditions)
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
    self.mediafiles.select{|mediafile| mediafile.mediafile_type == "Audiofile"}
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
  
  # Shell class for Article::Author
  class Author < Author
  end
  
end

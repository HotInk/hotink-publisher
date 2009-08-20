class Issue < HyperactiveResource

  has_many :article
  belongs_to :account, :nested => true

  self.site = HOTINK_SETTINGS.site
  self.prefix = "/accounts/:account_id/"

  def to_liquid
    {   'date' => self.date,
        'description' => self.description,
        'name' => self.name, 
        'number' => self.number, 
        'volume' => self.volume, 
        'articles' => articles,
        'press_pdf_url' => self.press_pdf_file, 
        'screen_pdf_url' => self.screen_pdf_file, 
        'large_cover_image' => self.large_cover_image,
        'small_cover_image' => self.small_cover_image,
        'id' => self.id,
        'account_id' => self.account_id
    }
  end
  
  def articles
    articles = Article.find(:all, :from => "/accounts/#{self.account.account_resource_id.to_s}/issues/#{self.id.to_s}/articles.xml", :as => self.account.access_token)
  end

end

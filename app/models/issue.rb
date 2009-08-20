class Issue < HyperactiveResource

  has_many :article
  belongs_to :account, :nested => true

  self.site = HOTINK_SETTINGS.site
  self.prefix = "/accounts/:account_id/"

  def to_liquid(options = {})
    Liquid::ArticleDrop.new self, options
  end

end

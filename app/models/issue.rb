class Issue < HyperactiveResource

  has_many :article
  belongs_to :account, :nested => true

  self.site = HOTINK_SETTINGS.site
  self.user = HOTINK_SETTINGS.user
  self.password = HOTINK_SETTINGS.password
  self.prefix = "/accounts/:account_id/"

  def to_liquid(options = {})
    Liquid::IssueDrop.new self, options
  end

end

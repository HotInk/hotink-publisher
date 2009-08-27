class Issue < HyperactiveResource

  has_many :article
  belongs_to :account, :nested => true

  self.prefix = "/accounts/:account_id/"

  def to_liquid(options = {})
    @issue_drop ||= Liquid::IssueDrop.new self, options
  end

end

class Issue < ActiveResource::Base

  self.site = HOTINK_SETTINGS[:site]
  self.prefix = "/accounts/:account_id/"

  def to_liquid(options = {})
    @issue_drop ||= Liquid::IssueDrop.new self, options
  end
  
  def cache_key
    "issues/#{self.id}"
  end
  
  def account
    account_resource_id = self.prefix_options[:account_id] || self.account_id
    @account ||= Account.find_by_account_resource_id(account_resource_id)
  end

end

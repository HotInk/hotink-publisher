class Liquid::NewspaperDrop < Liquid::BaseDrop
  
  def initialize(account, options = {})
    @account = account
  end

  def sections
    @account.sections
  end
  
  def name
    @account.name
  end
  
  def latest_issue
    Issue.find(:first, :account_id => @account.id)
  end
  
end
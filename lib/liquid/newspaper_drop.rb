class Liquid::NewspaperDrop < Liquid::BaseDrop
  
  def initialize(account, options = {})
    @account = account
  end

  def url
    @account.url
  end

  def sections
    @sections ||= @account.sections
  end
  
  def pages
    @account.pages
  end
  
  def name
    @account.name
  end
  
  def latest_issue
    @latest_issue ||= Issue.find(:first, :account_id => @account.id, :as => @account.access_token)
  end
  
  def latest_issues
    @latest_issues ||= Issue.find(:all, :account_id => @account.id, :as => @account.access_token)
  end
  
end
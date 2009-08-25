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
    unless @latest_issues
      @latest_issues = Issue.find(:all, :account_id => @account.id, :as => @account.access_token)
    end
    @latest_issues.first
  end
  
  def latest_issues
    @latest_issues ||= Issue.find(:all, :account_id => @account.id, :as => @account.access_token)
  end
  
  def latest_by_section
    unless @latest_articles_for_sections
      @latest_articles_for_sections = {}
      for article in Article.find(:all, :from => "/accounts/#{@account.id.to_s}/query.xml", :params => { :group_by => "section", :count => 5 }, :as => @account.access_token )
        if @latest_articles_for_sections[article.section]
          @latest_articles_for_sections[article.section] << article
        else
          @latest_articles_for_sections[article.section] = [article]
        end
      end
    end
    @latest_articles_for_sections
  end
  
end
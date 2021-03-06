class Liquid::NewspaperDrop < Liquid::BaseDrop
  
  def initialize(account, options = {})
    @account = account
  end

  # we need to phase this out. Semantically confusing
  def url
    if @account.url.blank?
      "/"
    else
      @account.url
    end
  end
  
  # used for linking to the home page. Prevents empty href's
  def homepage_url
    if @account.url.blank?
      "/"
    else
      @account.url
    end
  end
  
  # eg. doing {{newspaper.root_url}}/blogs - will work with or without a domain string
  def root_url
    @account.url
  end
  

  # Array of newspaper sections
  def sections
    @sections ||= @account.sections
  end
  
  def pages
    @account.pages
  end
  
  def blogs
    @account.blogs
  end
  
  def name
    @account.name
  end
  
  def latest_issues
     @latest_issues ||= get_latest_issues
  end
  
  def latest_issue
    unless @latest_issues
      @latest_issues = latest_issues
    end
    @latest_issues.first
  end
  
  # Returns hash of most recent articles keyed by section.
  def latest_by_section
    unless @latest_articles_for_sections
      @latest_articles_for_sections = {}
      for article in latest_articles_for_sections
        if @latest_articles_for_sections[article.section]
          @latest_articles_for_sections[article.section] << article
        else
          @latest_articles_for_sections[article.section] = [article]
        end
      end
    end
    @latest_articles_for_sections
  end
  
  # Returns 5 most recent blog entries
  def latest_entries
    unless @latest_entries
      @latest_entries = Rails.cache.fetch([@account.cache_key, '/latest_entries'], :expires_in => 10.minutes) do
          Entry.paginate(:all, :from => "/accounts/#{@account.account_resource_id.to_s}/entries.xml", :params => { :page => 1, :per_page => 5}) 
      end
    end
    @latest_entries
  end
  
  # Returns hash of recent blog entries, keyed by blog title
  def latest_from_blog
    unless @latest_entries_from_blogs
      @latest_entries_from_blogs = {}
      for entry in latest_entries_from_blogs
        if @latest_entries_from_blogs[entry.blogs.first.title]
          @latest_entries_from_blogs[entry.blogs.first.title] << entry
        else
          @latest_entries_from_blogs[entry.blogs.first.title] = [entry]
        end
      end
    end
    @latest_entries_from_blogs
  end
  
  private
  
  def get_latest_issues
    Rails.cache.fetch([@account.cache_key, '/latest_issues'], :expires_in => 10.minutes) do
      Issue.paginate(:all, :params => { :account_id => @account.account_resource_id, :page => 1, :per_page => 15 })
    end
  end
  
  def latest_articles_for_sections
    Rails.cache.fetch([@account.cache_key, '/latest_article_for_sections'], :expires_in => 10.minutes) do
      Article.find(:all, :from => "/accounts/#{@account.account_resource_id.to_s}/query.xml", :params => { :group_by => "section", :count => 5 })
    end
  end
  
  def latest_entries_from_blogs
    Rails.cache.fetch([@account.cache_key, '/latest_entries_from_blogs'], :expires_in => 10.minutes) do
      Entry.find(:all, :from => "/accounts/#{@account.account_resource_id.to_s}/query.xml", :params => { :group_by => "blog", :count => 5 })
    end
  end
  
end
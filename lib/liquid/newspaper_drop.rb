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
  
  def latest_issue
    unless @latest_issues
      @latest_issues = Issue.paginate(:all, :account_id => @account.id, :page => 1, :per_page => 15, :as => @account.access_token)
    end
    @latest_issues.first.issue.first.account.access_token = @account.access_token # We need to preserve access to this token for nested requests
    @latest_issues.first.issue.first
  end
  
  def latest_issues
      unless @latest_issues
        @latest_issues = Issue.paginate(:all, :account_id => @account.id, :page => 1, :per_page => 15, :as => @account.access_token)
      end
      @latest_issues.first.issue.collect do |i| 
        i.account.access_token = @account.access_token
        i
      end
  end
  
  # Returns hash of most recent articles keyed by section.
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
  
  # Returns 5 most recent blog entries
  def latest_entries
    unless @latest_entries
     @latest_entries = Entry.paginate(:all, :from => "/accounts/#{@account.id.to_s}/entries.xml", :params => { :page => 1, :per_page => 5}, :as => @account.access_token ) 
    end
    @latest_entries.first.article.collect do |i| 
      i
    end
  end
  
  # Returns hashof recent blog entries, keyed by blog title
  def latest_from_blog
    unless @latest_entries_from_blogs
      @latest_entries_from_blogs = {}
      for entry in Entry.find(:all, :from => "/accounts/#{@account.id.to_s}/query.xml", :params => { :group_by => "blog", :count => 5 }, :as => @account.access_token )
        if @latest_entries_from_blogs[entry.blogs.first.title]
          @latest_entries_from_blogs[entry.blogs.first.title] << entry
        else
          @latest_entries_from_blogs[entry.blogs.first.title] = [entry]
        end
      end
    end
    @latest_entries_from_blogs
  end
  
end
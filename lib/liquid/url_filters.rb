require 'uri'
require 'cgi'

module Liquid

  module UrlFilters
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::UrlHelper
    
    # include ActionController::UrlWriter
    # 
    # def link_to_section(section_id)
    #         
    #   @account = Account.find(controller.params[:account_id])
    #   @section = Section.find(section_id, :params => {:account_id => @account.id})
    #   link_for(account_issue_path(@account, @section))
    # end
    # 
    
    def link_to_article(article, title=nil)
       @account = @context.registers[:account] #Account.find(article.account_id)
       url = "#{@account.url}/articles/" + article["id"].to_s
       title ||= article["title"]
       link_to title, url
    end

    def link_to_blog(blog, title=nil)
       @account = @context.registers[:account] #Account.find(article.account_id)
       url = "#{@account.url}/blogs/" + blog["id"].to_s
       title ||= blog["title"]
       link_to title, url
    end
    
    def link_to_entry(entry, blog = nil, title=nil)
      @account = @context.registers[:account] #Account.find(article.account_id)
      title ||= entry["title"]
      if blog==nil
        url = "#{@account.url}/blogs/" + entry["blogs"].first.id.to_s + "/entries/" + entry["id"].to_s
      else
        url = "#{@account.url}/blogs/" + blog["id"].to_s + "/entries/" + entry["id"].to_s
      end
      link_to title, url
    end
    
    def link_to_issue(issue, title=nil)
      @account = @context.registers[:account] #Account.find(article.account_id)
      url = @account.url + "/issues/" + issue.id.to_s
      title ||= @issue["name"]
      link_to title, url
    end
  
    def link_to_section(section, title=nil)
      @account = @context.registers[:account] #Account.find(article.account_id)
      url = "#{@account.url}/sections/" + URI.escape(section["name"])
      title ||= section["name"]
      link_to title, url
    end
    
   def link_to_category(category, title=nil)
     link_to_section(category, title)
   end
    
    def link_to_page(page_name, title=nil)
      @account = @context.registers[:account] #Account.find(article.account_id)
      url = @account.url + "/" + URI.escape(page_name)
      title ||= page_name
      link_to title, url
    end
    
    def link_to_tag(tag, title=nil)
      @account = @context.registers[:account] #Account.find(article.account_id)
      url = "#{@account.url}/search?tagged_with=" + CGI.escape(tag["name"]) + "&page=1"
      title ||= tag["name"]
      link_to title, url
    end

    private

    def controller
      @context.registers[:controller]
    end
    
    
    def section_url(id)
      @s = Account.find(1).sections[0]
      @context.registers[:controller].url_for({:controller => "sections", 
        :action => "show", :account_id => @context['site'].account_id, :id => URI.escape(@s.name)})
    end

  end

end
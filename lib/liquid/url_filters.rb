module Liquid

  module UrlFilters
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::UrlHelper
    include ActionController::UrlWriter
    
    def link_to_section(id)
      @s = Account.find(1).issues[0]      
      link_for(account_issue_path(@s))
    end
    
    def link_to_issue(id)
      @i = Account.find(1).issues[0]
      link_for(account_issue_path(@i))
    end

    
    def link_to_issues(asd)
      link_for(account_issues_path)
    end
    
    def link_to_blogs
      link_for(account_blogs_path)
    end
    


    def link_for(url)
      content_tag :a, "asdfasdfasdfasd", { :href => url, :title => "asd" }
    end

    private

    def url_for(options = {})
      controller.url_for options
    end

    def controller()
      @context.registers[:controller]
    end
    
    
    def section_url(id)
      @s = Account.find(1).sections[0]
      @context.registers[:controller].url_for({:controller => "sections", 
        :action => "show", :account_id => @context['site'].account_id, :id => @s.name})
    end

  end

end
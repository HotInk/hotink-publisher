class Liquid::IssueDrop < Liquid::BaseDrop
    
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :name << :description  << :number << :volume << :date << :account_id << :id << :large_cover_image << :small_cover_image

  def initialize(source, options = {})
    super source
    @account = source.account unless @account
    @options  = options
  end

  def articles
    get_articles
  end
  
  def sections    
    unless @sections
      @sections = []
      for article in get_articles
        @sections << article.section unless @sections.include?(article.section)
      end
    end
    
    @sections
  end
  
  def articles_by_section
          
      unless @articles_by_section
        @articles_by_section = {}
        for article in get_articles
          if @articles_by_section[article.section]
            @articles_by_section[article.section] << article
          else
            @articles_by_section[article.section] = [article]
          end
        end
      end
      
      @articles_by_section
  end
  
  def has_pdf?
    source.press_pdf_file!="/images/no_issue_cover_small.jpg"
  end
  
  def press_pdf_url
    source.press_pdf_file
  end
  
  def screen_pdf_url
    source.screen_pdf_file
  end
  
  def url
    @account.url + "/issues/" + source.id.to_s
  end
  
  private
  
  def get_articles
    unless @articles
      @articles = Rails.cache.fetch([source.cache_key, '/articles'], :expires_in => 10.minutes) do
         Article.find(:all, :from => "/accounts/#{@account.account_resource_id.to_s}/issues/#{source.id.to_s}/articles.xml", :as => @account.access_token)
      end
    end
    @articles
  end

end
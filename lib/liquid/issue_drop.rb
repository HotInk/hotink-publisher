class Liquid::IssueDrop < Liquid::BaseDrop
    
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :name << :description  << :number << :volume << :date << :account_id << :id << :large_cover_image << :small_cover_image

  def initialize(source, options = {})
    super source
    @options  = options
  end

  def articles
      @articles ||= Article.find(:all, :from => "/accounts/#{source.account_id.to_s}/issues/#{source.id.to_s}/articles.xml", :as => source.account.access_token)
  end
  
  def articles_by_section
      @articles = Article.find(:all, :from => "/accounts/#{source.account_id.to_s}/issues/#{source.id.to_s}/articles.xml", :as => source.account.access_token) unless @articles
      
      unless @articles_by_section
        @articles_by_section = {}
        for article in @articles
          if @articles_by_section[article.section]
            @articles_by_section[article.section] << article
          else
            @articles_by_section[article.section] = [article]
          end
        end
      end
      
      @articles_by_section
  end
  
  def press_pdf_url
    source.press_pdf_file
  end
  
  def screen_pdf_url
    source.screen_pdf_file
  end

end
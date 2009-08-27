class ArticlesController < ApplicationController
  
  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables, :only => :show
  before_filter :require_design, :only => :show
  before_filter :find_template, :only => :show
  before_filter :build_registers, :only => :show
  
  # Since the show action is public facing, it should always fail in a predictable
  # informative way.
  def show
    
    # debugger
    
    @article = Article.find(params[:id], :account_id => @account.account_resource_id, :as => @account.access_token)
    @comments = @article.comments
    
  # Widget data processing -- start  
    # Build query of only the necessary ids, from the widgets
    schema_ids = Array.new
    @current_template.widgets.each do |widget|
      widget.schema.each_key do |item|
        schema_ids += widget.schema[item]['ids']
      end
    end

    unless schema_ids.blank?  
      article_resources = Article.find(:all, :ids => schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id, :as => @account.access_token)

      widget_data = {}
      schema_articles = {}

      article_resources.each do |article|
         schema_articles.merge!(article.id.to_s => article)
      end
    
      @current_template.widgets.each do |widget|
        widget.schema.each_key do |item|
          item_array = widget.schema[item]['ids'].collect{ |i| schema_articles[i] }
          widget_data.merge!( "#{item}_#{widget.name}" => item_array )
        end
      end
 
      # Set registers here 
      @registers[:widget_data] = widget_data
    end
    # Widget data processing -- end
    
    @registers[:account] = @account
    @registers[:design] = @current_template.design
    @registers[:form_authenticity_token] = self.form_authenticity_token
    @registers[:article] = @article
    
    page_html = @current_template.parsed_code.render({'article' => @article, 'newspaper' => @newspaper}, :registers => @registers )
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'article' => @article, 'newspaper' => @newspaper}, :registers => @registers)
    else  
      render :text => page_html
    end 
    #render :text => "Sorry, the page you were looking for could not be found.", :status => :not_found # If the current deisgn has no article template we should render 404
  end

end
  
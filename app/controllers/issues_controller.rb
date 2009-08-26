class IssuesController < ApplicationController

  skip_before_filter :require_user
  
  before_filter :set_liquid_variables
  before_filter :find_template

  before_filter :build_registers
  
  def show   
    @issue = Issue.find(params[:id], :account_id => @account.account_resource_id, :as => @account.access_token)
    @issue.account.access_token = @account.access_token # we have to preserve the access token for liquid requests
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
      @registers[:design] = @current_template.design if @current_template.design

      page_html = @current_template.parsed_code.render({'issue' => @issue, 'articles' => @articles, 'newspaper' => @newspaper}, :registers => @registers )
       if @current_template.current_layout
         render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'issue' => @issue, 'newspaper' => @newspaper}, :registers => @registers)
       else  
         render :text => page_html
       end
  end
    
  def index
    @issues = @account.issues
    @issues = @issues.collect do |i|
      i.account.access_token = @account.access_token
      i
    end
    
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
    @registers[:design] = @current_template.design if @current_template.design

    page_html = @current_template.parsed_code.render({'issues' => @issues, 'articles' => @articles, 'newspaper' => @newspaper}, :registers => @registers )
     if @current_template.current_layout
       render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'issues' => @issues, 'newspaper' => @newspaper}, :registers => @registers)
     else  
       render :text => page_html
     end
  end

end
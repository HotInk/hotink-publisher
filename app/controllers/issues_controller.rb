class IssuesController < ApplicationController

  skip_before_filter :require_user
  
  before_filter :set_liquid_variables
  before_filter :find_template

  before_filter :build_registers
  
  def show   
    @issue = Issue.find(params[:id], :params => { :account_id => @account.account_resource_id })
        # Widget data processing -- start  
        # Build query of only the necessary ids, from the widgets
        schema_ids = Array.new
        @current_template.widgets.each do |widget|
          widget.schema.each_key do |item|
            schema_ids += widget.schema[item]['ids']
          end
        end

        unless schema_ids.blank?  
          article_resources = Article.find_by_ids(schema_ids.reject{ |i| i.blank? }, :params => {:account_id => @account.account_resource_id})

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

      render :text => @current_template.render({'issue' => @issue, 'articles' => @articles, 'newspaper' => @newspaper}, :registers => @registers )
  end
    
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 15
    
    @issues = Issue.paginate(:all, :params => { :page => page, :per_page => per_page, :account_id => @account.account_resource_id })
    @issues_pagination = { 'current_page' => @issues.current_page, 'per_page' => @issues.per_page, 'total_entries' => @issues.total_entries }

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

    render :text => @current_template.render({'issues' => @issues.to_a, 'issues_pagination' => @issues_pagination,  'newspaper' => @newspaper}, :registers => @registers )
  end

end
class PagesController < ApplicationController
  
  skip_before_filter :require_user, :only => :show
  
  before_filter :set_liquid_variables, :only => :show
  before_filter :require_design, :only => :show
  
  before_filter :find_template, :only => :show
  before_filter :build_registers, :only => :show

  layout 'admin', :except => :show

  def show
    
    @page = @account.pages.find_by_name(params[:page_name])
    
    if @page.nil? 
      begin
        @section = Section.find(params[:page_name], :account_id => @account.account_resource_id, :as => @account.access_token)      
        if @section.nil?
          zissou
          return
        else
          redirect_to "/sections/#{URI.escape(@section.name)}", :status=>:moved_permanently
          return
        end
      rescue NoMethodError # Catch case that "section" we think we have isn't a real section at all 
        zissou
        return
      end
    end

    # Widget data processing -- start  
       # Build query of only the necessary ids, from the widgets
       schema_ids = Array.new
       found_widgets = @current_template.widgets
       found_widgets += @current_template.current_layout.widgets if @current_template.current_layout
       found_widgets.each do |widget|
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

         found_widgets.each do |widget|
           widget.schema.each_key do |item|
             item_array = widget.schema[item]['ids'].collect{ |i| schema_articles[i] }
             widget_data.merge!( "#{item}_#{widget.name}" => item_array )
           end
         end

         # Set registers here 
         @registers[:widget_data] = widget_data
       end
       # Widget data processing -- end

    # Set registers here 
    @registers[:account] = @account
    @registers[:design] = @current_template.design if @current_template.design

    page_html = @current_template.parsed_code.render({'page' => @page, 'newspaper' => @newspaper}, :registers => @registers )
    if @current_template.current_layout
      render :text => @current_template.current_layout.parsed_code.render({'page_content' => page_html, 'newspaper' => @newspaper}, :registers => @registers)
    else  
      render :text => page_html
    end    
    
  end
  
  
  def index
    @pages = Page.find_all_by_account_id(@account.id)
  end


  def new
    @page = Page.new
  end


  def edit
    @page = @account.pages.find(params[:id])    
  end


  def create
    @page = @account.pages.build(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to account_pages_path(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update    
    @page = @account.pages.find(params[:id])
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to account_pages_path(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end    
  end


  def destroy
    @page = @account.pages.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(account_pages_url(@account)) }
      format.xml  { head :ok }
    end
  end

end
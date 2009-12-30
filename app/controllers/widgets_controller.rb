class WidgetsController < ApplicationController

  layout 'admin'

  def new
      respond_to do |format|
        format.html
        format.js
      end
  end
  
  # GET /front_pages/1/edit
  def edit
    @design = @account.designs.find(params[:design_id])
    @widget = @design.widgets.find(params[:id])
    page = params[:page] || 1
    schema_ids = Array.new
    
    if @widget.schema.respond_to?(:each_key)    
      @widget.schema.each_key do |item|
        schema_ids += @widget.schema[item]['ids'] unless @widget.schema[item]['ids'].blank?
      end
    end
    
    @schema_articles = {}
    article_resources = Article.find_by_ids(schema_ids.reject{ |i| i.blank? }, :account_id => @account.account_resource_id) unless schema_ids.blank?
    article_resources.each do |article|
      @schema_articles.merge!(article.id => article)
    end
      
    @articles = Article.paginate(:params => { :page => page, :per_page => 10, :account_id => @account.account_resource_id } )

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  
  def create
    @design = @account.designs.find(params[:design_id])
    @widget = @design.widgets.build

    # Process the schema template into a real schema
    @widget_template = @design.widget_templates.find(params[:template])
    @widget.schema = @widget_template.parse_schema
    @widget.template = @widget_template
        
    respond_to do |format|
      if @widget.save(false)
        flash[:notice] = 'Widget was successfully created.'
        format.html { redirect_to(edit_account_design_widget_path(@account, @design, @widget)) }
        format.xml  { render :xml => @widget, :status => :created, :location => [@account, @design, @widget] }
      else
        flash[:error] = "Error building new widget from template."
        format.html { redirect_to account_control_panel_url(@account) }
        format.xml  { render :xml => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @design = @account.designs.find(params[:design_id])
    @widget = @design.widgets.find(params[:id])

    @widget.schema = params[:schema]
    respond_to do |format|
      if @widget.update_attributes(params[:widget])
        flash[:notice] = 'Widget was successfully updated.'
        format.html { redirect_to(account_control_panel_path(@account)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @design = @account.designs.find(params[:design_id])
    @widget = @design.widgets.find(params[:id])
    @widget.destroy
    flash[:notice] = "Widget destroyed"
    respond_to do |format|
      format.html { redirect_to(account_control_panel_url(@account)) }
      format.xml  { head :ok }
    end
  end

end

class WidgetsController < ApplicationController

  layout 'admin'

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # GET /designs/1/widgets/1/edit
  def edit
    page = params[:page] || 1
    @articles = Article.paginate(:params => { :page => page, :per_page => 10, :account_id => @account.account_resource_id } )

    respond_to do |format|
      format.html do
        @design = @account.designs.find(params[:design_id])
        @widget = @design.widgets.find(params[:id])
        @schema_articles = hash_by_id(Article.find_by_ids(@widget.schema_article_ids, :account_id => @account.account_resource_id))
      end
      format.js
    end
  end
  
  # POST /designs/1/widgets  
  def create
    @design = @account.designs.find(params[:design_id])

    # Process the schema template into a real schema
    @widget_template = @design.widget_templates.find(params[:template])
    @widget = @design.widgets.create(:schema => @widget_template.parse_schema, :template => @widget_template)
    flash[:notice] = 'Widget was successfully created.'

    respond_to do |format|
      format.html { redirect_to(edit_account_design_widget_path(@account, @design, @widget)) }
    end
  end
  
  def update
    @design = @account.designs.find(params[:design_id])
    @widget = @design.widgets.find(params[:id])
    
    @widget.schema = params[:schema]
    @widget.update_attributes(params[:widget])
    flash[:notice] = 'Widget was successfully updated.'
    
    respond_to do |format|
      format.html { redirect_to(account_control_panel_path(@account)) }
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

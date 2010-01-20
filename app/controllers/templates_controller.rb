class TemplatesController < ApplicationController
  
  layout 'admin'
  
  before_filter :find_design
  
  # Can't use @template as an instance variable!

  # GET /templates/new
  # GET /templates/new.xml
  def new
    
    case params[:role]
    when nil
      raise ArgumentError, "Must assign a template role"
    when 'layout'
      @tplate = @design.layouts.build(:role => 'layout')
    when 'partial'
      @tplate = @design.partial_templates.build(:role => 'partial')
    when 'front_pages/show'
      @tplate = @design.front_page_templates.build(:role => 'front_pages/show')
      @tplate.schema = []
    when 'widget'
      @tplate = @design.widget_templates.build(:role => 'widget')
      @tplate.schema = []
    else
      @tplate = @design.page_templates.build(:role => params[:role])
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /templates/1/edit
  def edit
    @tplate = @design.templates.find(params[:id])
  end

  # POST /templates
  def create
    # Find template attributes
    model_params = params[:template] || params[:layout] || params[:partial_template] || params[:front_page_template]  || params[:widget_template]|| params[:page_template]
    
    case model_params[:role]
    when 'layout' 
      @tplate = @design.layouts.build(model_params)
    when 'partial'
       @tplate = @design.partial_templates.build(model_params)
    when 'front_pages/show'
      @tplate = @design.front_page_templates.build(model_params)
      @tplate.schema = (model_params[:schema] || []) # assign serialized attribute explicitly
    when 'widget'
      @tplate = @design.widget_templates.build(model_params)
      @tplate.schema = (model_params[:schema] || []) # assign serialized attribute explicitly
    else
      @tplate = @design.page_templates.build(model_params)
    end
    
    respond_to do |format|
      if @tplate.save
        flash[:notice] = 'Template was successfully created.'
        format.html { redirect_to edit_account_design_template_path(@account, @design, @tplate) }
      else
        format.html { render :action => "new" }
      end
    end
    
  rescue Liquid::SyntaxError => e
    flash[:syntax_error] = "#{e.message}"
    respond_to do |format|
      format.html { render :action => "new" }
    end    
  end

  # PUT /templates/1
  # PUT /templates/1.xml
  def update    
    @tplate = @design.templates.find(params[:id])

    # Serialized attributes need to be declared explicitly.
    @tplate.schema = (params[@tplate.class.name.underscore.to_sym][:schema] || []) if @tplate.kind_of? WidgetTemplate
     
    unless @tplate.class.name=="WidgetTemplate"
     @tplate.widgets.clear 
     Marshal.load(@tplate.parsed_code).root.nodelist.select{ |c| c.is_a? Liquid::Widget }.each do |widget|
      logger.info("Found widget: #{widget.widget_name[1..-2]} \n")
      widget_object = @design.widgets.find_by_name(widget.widget_name[1..-2])
      @tplate.widgets << widget_object if widget_object
     end
    end
    
    respond_to do |format|
      if @tplate.update_attributes(params[@tplate.class.name.underscore.to_sym])
        flash[:notice] = 'Template was successfully updated.'
        format.html { redirect_to( account_design_url(@account,@design) ) }
      else
        format.html { render :action => "edit" }
      end
    end
    
  rescue Liquid::SyntaxError => e
    flash[:syntax_error] = "#{e.message}"
    @tplate.code = params[@tplate.class.name.underscore.to_sym][:code]
    respond_to do |format|
      format.html { render :action => "edit" }
    end
  end

  # DELETE /templates/1
  def destroy
    @tplate = @design.templates.find(params[:id])

    @tplate.active = false
    @tplate.save
    
    flash[:notice] = "Template removed."
    respond_to do |format|
      format.html { redirect_to(account_design_url(@account, @design)) }
    end
  end
end

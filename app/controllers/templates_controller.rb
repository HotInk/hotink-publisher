class TemplatesController < ApplicationController
  
  layout 'admin'
  
  before_filter :find_design
  
  # Can't use @template as an instance variable!
  
  # GET /templates
  # GET /templates.xml
  def index
    @tplates = @design.templates.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tplates }
    end
  end

  # GET /templates/1
  # GET /templates/1.xml
  def show
    @tplate = @design.templates.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tplate }
    end
  end

  # GET /templates/new
  # GET /templates/new.xml
  def new
    
    @tplate = @design.templates.build
    @tplate.role = params[:role]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tplate }
    end
  end

  # GET /templates/1/edit
  def edit
    @tplate = @design.templates.find(params[:id])
  end

  # POST /templates
  # POST /templates.xml
  def create
    
    case params[:template][:role]
    when 'layout' 
      @tplate = @design.layouts.build(params[:template])
    when 'front_pages/show'
      @tplate = @design.front_page_templates.build(params[:template])
      @tplate.schema = (params[:template][:schema] || {}) # assign serialized attribute explicitly
    else
      @tplate = @design.page_templates.build(params[:template])
    end
    
    # Pre-parse the template in the controller, it can't happen in the model
    @tplate.parsed_code = Liquid::Template.parse(@tplate.code)
    
    respond_to do |format|
      if @tplate.save
        flash[:notice] = 'Template was successfully created.'
        format.html { redirect_to edit_account_design_template_path(@account, @design, @tplate) }
        format.xml  { render :xml => @tplate, :status => :created, :location => [@account, @design, @tplate] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tplate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /templates/1
  # PUT /templates/1.xml
  def update    
    @tplate = @design.templates.find(params[:id])

    # Serialized attributes need to be declared explicitly.
    @tplate.schema = (params[:front_page_template][:schema] || {}) if @tplate.is_a? FrontPageTemplate
    # Pre-parse the template in the controller, it can't happen in the model
    @tplate.parsed_code = Liquid::Template.parse(params[@tplate.class.name.underscore.to_sym][:code])
    
    
    @tplate.save # And saved explicitly
    
    respond_to do |format|
      if @tplate.update_attributes(params[@tplate.class.name.underscore.to_sym])
        flash[:notice] = 'Template was successfully updated.'
        format.html { redirect_to( account_design_url(@account,@design) ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tplate.errors, :status => :unprocessable_entity }
      end
    end
  rescue Liquid::SyntaxError => e
    flash[:syntax_error] = "#{e.message}"
    respond_to do |format|
      format.html { render :action => "edit" }
      format.xml  { head :uprocessable_entity }
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.xml
  def destroy
    @tplate = @design.templates.find(params[:id])
    @tplate.destroy

    respond_to do |format|
      format.html { redirect_to(account_design_url(@account, @design)) }
      format.xml  { head :ok }
    end
  end
end

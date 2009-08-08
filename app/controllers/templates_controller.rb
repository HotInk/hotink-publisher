class TemplatesController < ApplicationController
  
  layout 'admin'
  
  before_filter :find_design
  
  # Can't use @template as an instance variable!
  
  # GET /templates
  # GET /templates.xml
  def index
    @tplates = @account.templates.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tplates }
    end
  end

  # GET /templates/1
  # GET /templates/1.xml
  def show
    @tplate = @account.templates.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tplate }
    end
  end

  # GET /templates/new
  # GET /templates/new.xml
  def new
    @tplate = @account.templates.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tplate }
    end
  end

  # GET /templates/1/edit
  def edit
    @tplate = @account.templates.find(params[:id])
  end

  # POST /templates
  # POST /templates.xml
  def create
    @tplate = @account.templates.build(params[:template])

    respond_to do |format|
      if @tplate.save
        flash[:notice] = 'Template was successfully created.'
        format.html { redirect_to([@account, @tplate]) }
        format.xml  { render :xml => @tplate, :status => :created, :location => [@account, @tplate] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tplate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /templates/1
  # PUT /templates/1.xml
  def update
    @tplate = @account.templates.find(params[:id])

    respond_to do |format|
      if @tplate.update_attributes(params[:template])
        flash[:notice] = 'Template was successfully updated.'
        format.html { redirect_to([@account,@tplate]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tplate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.xml
  def destroy
    @tplate = @account.templates.find(params[:id])
    @tplate.destroy

    respond_to do |format|
      format.html { redirect_to(account_templates_url(@account)) }
      format.xml  { head :ok }
    end
  end
end

class TemplateFilesController < ApplicationController

  layout 'admin'

  def new
    @design = @account.designs.find(params[:design_id])
    @template_file = @design.template_files.build
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @design = @account.designs.find(params[:design_id])
    @template_file = TemplateFile.find_by_file_file_name_and_design_id( sanitized_name_of(params[:template_file][:file]), @design.id )
    if @template_file
      @template_file.active = true
    else
      @template_file = @design.template_files.build(params[:template_file])
      case @template_file.file_name.split('.')[-1]
      when 'js', 'htc'
        @template_file = JavascriptFile.new(@template_file.attributes)
      when 'css'
        @template_file = Stylesheet.new(@template_file.attributes) 
      end
    end
    
    @template_file.file = params[:template_file][:file]
    @template_file.save!
    redirect_to [@account, @design]    
  end
  
  def edit
    @design = @account.designs.find(params[:design_id])
    @template_file = @design.template_files.find(params[:id])
    
    if @template_file.is_a?(Stylesheet)||@template_file.is_a?(JavascriptFile)
      @file_contents = File.read(@template_file.file.path)
    else
      flash[:notice] = "You can only edit stylesheets and javascript files. To edit another file type, follow the replace link next to the filename."
      redirect_to account_design_url(@account, @design)
      return
    end
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    @design = @account.designs.find(params[:design_id])
    @template_file = @design.template_files.find(params[:id])  

    File.open(@template_file.file.path, 'w+') do |t|
      t.puts params[:file_contents]
      @template_file.file = t
    end

    @template_file.save!
    flash[:notice] = '<span style="color:green;">File updated</span>'
    redirect_to edit_account_design_template_file_path(@account, @design)
  end
  
  def destroy
    @design = @account.designs.find(params[:design_id])
    @template_file = @design.template_files.find(params[:id])
    @template_file.update_attribute(:active, false) # @template_file.destroy
    flash[:notice] = "Template file removed."
    redirect_to [@account, @design]
  end

private
  
  def sanitized_name_of(file)
    File.basename( file.original_filename ).gsub(/[^\w\.\_]/,'_')
  end
  
end

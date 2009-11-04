class DesignImportsController < ApplicationController
  
  def new
    @designs = Design.find_all_by_public(true, :order => "created_at DESC")
  end
  
  def create
    if current_user.account.id == 1
      @design = Design.new
      @design_to_import = Design.find_by_id_and_account_id(params[:design_id])
      @design.attributes = @design_to_import.attributes
      @design.parent = @design_to_import
      @design.public = false
      @design.account = @account
      @design.save  
    
      for template in @design_to_import.templates
        new_template = template.clone
        new_template.design = @design
        new_template.parsed_code = Liquid::Template.parse(template.code)
        new_template.save
      end
    
      for template_file in @design_to_import.template_files
        new_template_file = template_file.clone
        new_template_file.design = @design
        new_template_file.file = template_file.file
        new_template_file.save
      end

    end
  end
  
  def show
  end
  
end

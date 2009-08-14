module Liquid

  module DesignFilters
    
    def template_file(filename)
      
      # TODO: get this from the @context somehow
      @account = Account.find(7)
      
      design = @account.current_design 
      template_file = design.template_files.find_by_file_file_name(filename)

      if template_file
        # TODO: get this from the context somehow
        "http://localhost:3000" + template_file.url 
      end
    end

  end
  
end




module Liquid

  module DesignFilters
    
    def template_file(filename)
      @account = @context.registers[:account]
      if @account
        @design = @context.registers[:design].nil? ? @account.current_design : @context.registers[:design]

        template_file = @design.template_files.find_by_file_file_name(filename)

        case template_file.file_name.split('.')[-1]  
        when 'js', 'htc'
            "<script src=\"#{template_file.url}\" type=\"text/javascript\" charset=\"utf-8\"></script>"
        when 'png', 'jpg', 'gif', 'jpeg'
            "<img src=\"#{template_file.url}\" />"
        when 'css'
            "<link rel=\"stylesheet\" type=\"text/css\" media=\"all\" href=\"#{template_file.url}\" />"
        else
            "<a href=\"#{template_file.url}\" name=\"#{template_file.file_name}\">#{ template_file.file_name }</a>" 
        end
      end
    end

    def template_file_url(filename)
      @account = @context.registers[:account]
      if @account
        @design = @context.registers[:design].nil? ? @account.current_design : @context.registers[:design]
        template_file = @design.template_files.find_by_file_file_name(filename)
        template_file.file.url
      end
    rescue
      ""
    end

  end
  
  Template.register_filter(DesignFilters)
end

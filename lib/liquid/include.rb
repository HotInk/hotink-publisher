module Liquid
  class Include < Tag
    Syntax = /(#{QuotedFragment}+)(\s+(?:with|for)\s+(#{QuotedFragment}+))?/
  
    def initialize(tag_name, markup, tokens)      
      if markup =~ Syntax

        @template_name = $1        
        @variable_name = $3
        @attributes    = {}
      end

      super
    end
  
    def parse(tokens)      
    end
  
    def render(context)      
      design = context.registers[:design].blank? ? context.registers[:account].current_design : context.registers[:design]
      partial = design.partial_templates.find_by_name(context[@template_name])     
      
      variable = context[@variable_name || @template_name[1..-2]]
      
      context.stack do
        if variable.is_a?(Array)
          
          variable.collect do |variable|            
            context[@template_name[1..-2]] = variable
            partial.render(context)
          end

        else
                    
          context[@template_name[1..-2]] = variable
          partial.render(context)
        end
      end
    end
  end  
  Template.register_tag('include', Include)
end
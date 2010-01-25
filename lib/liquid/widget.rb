module Liquid
  class Widget < Tag
    Syntax = /(#{QuotedFragment}+)?/
  
    def initialize(tag_name, markup, tokens)      
      if markup =~ Syntax

        @widget_name = $1        

      else
        raise SyntaxError.new("Error in tag 'widget' - Valid syntax: widget 'widget name'")
      end

      super
    end
    
    # Expose widget name for widgetfinder
    def widget_name
      @widget_name
    end
  
    def parse(tokens)      
    end
  
    def render(context)      
      design = context.registers[:design].blank? ? context.registers[:account].current_design : context.registers[:design]
      widget = design.widgets.find_by_name(context[@widget_name])
      
      context.stack do
        widget.schema.each_key do |item|
          item_array = context.registers[:widget_data]["#{item}_#{widget.name}"]
          context[item] = item_array
        end
        widget.render(context)
      end
    end

  end

  Liquid::Template.register_tag('widget', Widget)  
end
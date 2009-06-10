module Liquid
class Themeitem < Liquid::Block

   @@image_exts = %w( .png .jpg .jpeg .jpe .gif )
   @@stylesheet_exts = %w( .css )
   @@javascript_exts = %w( .js .htc )
                                      
   def render(context)
      # Which, if either, of these are correct?

      context.has_key?('request') ? base_url = context['request'].relative_url_root : ActionController::Base.asset_host.to_s
      theme_name = @theme_name || context['active_theme']

      filename = @nodelist.join('').strip
      ext = File.extname( filename )

      if @@image_exts.include?( ext )
         "#{base_url}/themes/#{theme_name}/images/#{filename}"

      elsif @@stylesheet_exts.include?( ext )
         "#{base_url}/themes/#{theme_name}/stylesheets/#{filename}"
         
      elsif @@javascript_exts.include?( ext )
         "#{base_url}/themes/#{theme_name}/javascript/#{filename}"
      end
   end   
end
end
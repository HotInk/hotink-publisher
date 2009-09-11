class Liquid::BlogDrop < Liquid::BaseDrop
  liquid_attributes << :title << :description  << :id << :updated_at
  
  def initialize(source, options = {})
     super source
     @account = source.account unless @account
     @options  = options
   end
  
end
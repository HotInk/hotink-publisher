class Liquid::BlogDrop < Liquid::BaseDrop
  liquid_attributes << :title << :description << :updated_at
  
  def initialize(source, options = {})
     super source
     @account = source.account unless @account
     @options  = options
   end
   
   def id
     source.id
   end
  
end
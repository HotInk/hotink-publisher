class Liquid::TemplateFileDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :title << :subtitle  << :id

  def initialize(source, options = {})
    super source
    @options  = options
    @liquid.update \
      'bodytext' => @source.bodytext
  end
  
  def id
    source.id
  end
    
end
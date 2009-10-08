class Liquid::CommentDrop < Liquid::BaseDrop
  
  include ERB::Util # So we can simply use <tt>h(...)</tt>.
  
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  liquid_attributes << :name << :body << :type << :id

  def initialize(source, options = {})
    super source
    @options  = options
  end
  
  def article
    source.article
  end
  
  def date
    source.created_at
  end
    
end
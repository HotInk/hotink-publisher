class Widget < ActiveRecord::Base
  belongs_to :design
  validates_presence_of :design
  
  belongs_to :template 
  validates_presence_of :template

  has_many :widget_placements, :dependent => :destroy
  has_many :templates, :through => :widget_placements

  serialize :schema
  
  validates_uniqueness_of :name, :scope => :design_id
  
  # Return the schema article ids if provided  
  def schema_article_ids
    ids = []
    if self.schema.respond_to?(:each_key)
      self.schema.each_key do |item|
        ids += self.schema[item]['ids']
      end
    end
    ids
  end
  
  def render(options={}, registers={})
    template.render(options,registers)
  end

end

class Template < ActiveRecord::Base
  belongs_to :design
  validates_presence_of :design
  
  has_many :widget_placements
  has_many :widgets, :through => :widget_placements
  
  
  acts_as_versioned
    
  # Returns an array of the ids of all articles used in widgets 
  # or used in template code.
  def required_article_ids
    data_ids = []
    self.all_widgets.each do |widget|
      widget.schema.each_key do |item|
        data_ids += widget.schema[item]['ids']
      end
    end
    data_ids
  end
  
  # Returns all widgets, not just those belonging to this template
  # Should be overridden by subclasses to add whatever other widgets
  # are necessary to render the page.
  def all_widgets
    self.widgets
  end
  
  # Takes a collection of fetched articles (presumably including all articles required by this template's widgets)
  # and returns a hash of widget articles keyed according to schema entity and widget_name
  def parsed_widget_data(schema_articles = {})
    widget_articles = {}
    unless schema_articles.blank?
      self.all_widgets.each do |widget|
        widget.schema.each_key do |item|
          item_array = widget.schema[item]['ids'].collect{ |i| schema_articles[i] }
          widget_articles.merge!( "#{item}_#{widget.name}" => item_array.compact )
        end
      end
    end
    widget_articles
  end
  
  def name
    return read_attribute('name') unless read_attribute('name').blank?
    "(Unnamed template)"
  end
  
  #You gotta parse in the controller. Here to save you have to...serialize.
  #serialize :parsed_code, Liquid::Template
  def parsed_code=(parsed_liquid_template)
    write_attribute(:parsed_code, Marshal::dump(parsed_liquid_template))
  end
  
  def parsed_code
    @parsed_code ||= Marshal::load( read_attribute(:parsed_code) )
  end
  
end
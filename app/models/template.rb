class Template < ActiveRecord::Base
  belongs_to :design
  validates_presence_of :design
  
  has_many :widget_placements, :dependent => :destroy
  has_many :widgets, :through => :widget_placements
  
  before_save :parse_code
  after_save  :find_widgets
  
  acts_as_versioned
  
  def name
    return read_attribute('name') unless read_attribute('name').blank?
    "(Unnamed template)"
  end

  # A before filter to parse the Liquid template stored in self.code
  def parse_code
    write_attribute(:parsed_code, Marshal::dump(Liquid::Template.parse(self.code)))
  end
  
  def rendered_template
    Marshal.load(parsed_code)
  end
  
  # Render parsed Liquid template code
  def render(options=nil, registers = nil)
    parsed_code = Marshal::load(read_attribute(:parsed_code))
    parsed_code.render(options, registers)
  end 
    
  # Returns an array of the ids of all articles used in widgets.
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
          item_array = widget.schema[item]['ids'].collect{ |i| schema_articles[i.to_s] }
          widget_articles.merge!( "#{item}_#{widget.name}" => item_array.compact )
        end
      end
    end
    widget_articles
  end
  
  private
  
  def find_widgets
    widgets.clear
    rendered_template.root.nodelist.select{ |c| c.is_a? Liquid::Widget }.each do |widget|
      widget_object = design.widgets.find_by_name(widget.widget_name[1..-2])
      widgets << widget_object if widget_object
    end
  end
    
end
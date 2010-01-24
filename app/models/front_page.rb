class FrontPage < ActiveRecord::Base  
  belongs_to :account
  validates_presence_of :account
  validates_associated :account
  
  belongs_to :template
  validates_presence_of :template
  validates_associated :template

  belongs_to :design
  validates_associated :design  
  
  has_many :press_runs
  
  named_scope :drafts, :joins => 'LEFT JOIN press_runs ON front_pages.id=press_runs.front_page_id', :conditions => 'front_page_id is NULL'
    
  serialize :schema 
  
  acts_as_versioned
  
  def friendly_date
    return "#{self.created_at.to_formatted_s(:long_date)} #{self.created_at.to_formatted_s(:time)}"
  end
  
  # Since front pages are initialized and save as blank, we can tell whether they've been changed
  # based on whether or not the time created equals the time last updated, (e.g. only one save
  # operation has been performed, no effective updates.)
  def unchanged?
    created_at == updated_at
  end
  
  def display_name
    if self.name and self.name.strip != ""
      return self.name
    else 
      return "Front page"
    end
  end
  
  # Return the Front Page schema article ids if provided  
  def schema_article_ids
    ids = []
    if self.schema.respond_to?(:each_key)
      self.schema.each_key do |item|
        ids += self.schema[item]['ids']
      end
    end
    ids
  end
  
  # Takes a collection of fetched articles (presumably including this front page's articles)
  # and returns a hash of this front page's articles keyed according to schema entity
  def sorted_schema_articles(schema_articles = {})
   articles = {}
   if self.schema.respond_to?(:each_key) && !schema_articles.blank?
      self.schema.each_key do |item|
        item_array = self.schema[item]['ids'].collect{ |i| schema_articles[i.to_s] }
        articles.merge!( item => item_array.compact )
      end
    end
    articles
  end
  
  def render(options={}, registers={})
    template.render(options,registers)
  end
  
end

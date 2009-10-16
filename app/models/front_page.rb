class FrontPage < ActiveRecord::Base
  belongs_to :account
  belongs_to :template
  belongs_to :design
  
  has_many :press_runs
  
  validates_presence_of :account
  
  validates_associated :account
  validates_associated :template
  validates_associated :design
  
  serialize :schema 
  
  acts_as_versioned
  
  def friendly_date
    return "#{self.created_at.to_formatted_s(:long_date)} #{self.created_at.to_formatted_s(:time)}"
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
  # and returns a hash of this front pages articles keyed according to schema entity
  def sorted_schema_articles(schema_articles = {})
   articles = {}
   if self.schema.respond_to?(:each_key) && !schema_articles.blank?
      self.schema.each_key do |item|
        item_array = self.schema[item]['ids'].collect{ |i| schema_articles[i] }
        articles.merge!( item => item_array.compact )
      end
    end
    articles
  end
  
end

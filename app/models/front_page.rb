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
  
  has_attached_file   :webthumb, 
                      :path => ":rails_root/public/system/webthumbs/:id/thumb.jpg", 
                      :url => "/system/webthumbs/:id/thumb.jpg"
  
  def friendly_date
    return "#{self.created_at.to_formatted_s(:long_date)} #{self.created_at.to_formatted_s(:time)}"
  end
  
  # DelayedJob for web thumb processing
  def perform
    job = Webthumb.new('1a4c9ab213872200bf938020ecdeecb4').thumbnail(:url => 'http://publisher.hotink.theorem.ca/accounts/36') #, :custom_thumbnail => { :width => '206', :height => '200' })
    Tempfile.open("fp") do |file|
      file.write(job.fetch_when_complete(:large))
      webthumb = file
    end
    save
  end
  
  def webthumb_server
    @webthumb_server ||= Webthumb.new('1a4c9ab213872200bf938020ecdeecb4')
  end
  
  #after_update do |front_page|
  # Delayed::Job.enqueue WebthumbJob.new(front_page.id) # Reload Webthumb after update
  #end
  
  # Since front pages are initialzed and save as blank, we can tell whether they've been changed
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

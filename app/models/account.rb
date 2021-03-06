class Account < ActiveRecord::Base
    
  has_many :front_pages, :conditions => { :active => true }, :dependent => :destroy
  has_many :press_runs, :dependent => :destroy
  
  has_many :designs, :conditions => { :active => true }, :dependent => :destroy
  has_many :redesigns, :dependent => :destroy
  
  has_many :pages
  has_many :podcasts
  
  has_many :article_options
  
  validates_presence_of :account_resource_id
    
  def current_design 
    if current_redesign && current_redesign.design
      current_redesign.design
    else
      nil
    end  
  end
  
  def current_redesign(reload = false)
    unless reload
      @current_redesign ||= self.redesigns.find(:first, :order => "created_at DESC")
    else
      @current_redesign = self.redesigns.find(:first, :order => "created_at DESC")
    end      
  end
  
  def current_front_page 
    if current_press_run && current_press_run.front_page
      current_press_run.front_page
    else
      nil
    end  
  end
  
  def current_press_run(reload = false)
    unless reload
      @current_press_run ||= self.press_runs.find(:first, :order => "created_at DESC")
    else
      @current_press_run = self.press_runs.find(:first, :order => "created_at DESC")
    end      
  end  
  
  def sections
    Rails.cache.fetch([self.cache_key, '/sections'], :expires_in => 10.minutes) do
      Section.find(:all, :params => { :account_id => self.account_resource_id })
    end
  end
  
  def blogs
    @blogs ||=  Blog.find(:all, :params => { :account_id => self.account_resource_id })
  end
  
  def cache_key
    "accounts/#{self.account_resource_id}"
  end
    
end

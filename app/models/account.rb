class Account < ActiveRecord::Base
  
  has_many :users
  
  has_many :front_pages, :conditions => { :active => true }, :dependent => :destroy
  has_many :press_runs, :dependent => :destroy
  
  has_many :designs, :conditions => { :active => true }, :dependent => :destroy
  has_many :redesigns, :dependent => :destroy
  
  has_many :pages
  
  has_many :article_options
    
  attr_accessor :access_token
  # has_many :articles
  
  # Load the current design and front page from the latest redesign and 
  # press run respectively.
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

  # Only make the Resource reload when absolutely necessart
  def account_resource(reload = false)
    unless reload
      @account_resource ||= AccountResource.find(self.account_resource_id, :as => self.access_token)
    else
      @account_resource = AccountResource.find(self.account_resource_id, :as => self.access_token)
    end
  end

  # def articles
  #   Article.find(:all, :params => {:account_id => self.account_resource_id})
  # end
  
  def sections
    Rails.cache.fetch([self.cache_key, '/sections'], :expires_in => 10.minutes) do
      Section.find(:all, :account_id => self.account_resource_id, :as => self.access_token)
    end
  end
  
  def issues
    @issues ||= Issue.find(:all, :account_id => self.account_resource_id, :as => self.access_token)
  end
  

  def blogs
    @blogs ||=  Blog.find(:all, :account_id => self.account_resource_id, :as => self.access_token)
  end
  
  # hack for HyperactiveResource
  def nested
    false
  end
  
  def account_resource
    if self.account_resource_id
      @account ||= AccountResource.find(self.account_resource_id, :as => self.access_token) 
    else
      @account ||= AccountResource.find(self.id, :as => self.access_token)
    end
  end
  
  def cache_key
    "accounts/#{self.account_resource_id}"
  end
    
end

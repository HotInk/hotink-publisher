class Section < HyperactiveResource

  self.site = HOTINK_SETTINGS.site
  # self.prefix = "/accounts/:account_id/"
  
  belongs_to :account, :nested => true
  
  def to_param
    self.name
  end  
  
  def to_liquid
    {'name' => self.name, 'position' => self.position, 'id' => self.id, 'subcategories' => self.children}
  end
  
  def test
    "dasd"
  end
    
  #Define class for api child categories
  class Child < Section
    def to_liquid
      {'name' => self.name, 'position' => self.position, 'id' => self.id, 'subcategories' => self.children}
    end
  end
  
end

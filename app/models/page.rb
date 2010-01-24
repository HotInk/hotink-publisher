class Page < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name, :scope=>:account_id
  
  belongs_to :account
  validates_presence_of :account
  
  def to_liquid
    {'bodytext' => self.bodytext, 'name' => self.name, 'id' => self.id, 'date' => self.date}
  end

end
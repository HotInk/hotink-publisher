class Page < ActiveRecord::Base

  validates_uniqueness_of :name, :scope=>:account_id

  belongs_to :account

  def to_liquid
    {'bodytext' => self.bodytext, 'name' => self.name, 'id' => self.id, 'date' => self.date}
  end

end
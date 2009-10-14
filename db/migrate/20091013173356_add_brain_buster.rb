class AddBrainBuster < ActiveRecord::Migration
  class BrainBuster < ActiveRecord::Base; end;
  
  def self.up
    create_table "brain_busters", :force => true do |t|
      t.column :question, :string
      t.column :answer, :string
    end
    
    create "What month comes before July?", "june"
    create "What is 14 minus 4?", "10"
  end

  def self.down
    drop_table "brain_busters"
  end
  
  # create a logic captcha - answers should be lower case
  def self.create(question, answer)
    BrainBuster.create(:question => question, :answer => answer.downcase)
  end
  
end
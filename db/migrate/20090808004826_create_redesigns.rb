class CreateRedesigns < ActiveRecord::Migration
  def self.up
    create_table :redesigns do |t|
      t.integer :account_id
      t.integer :design_id
      t.integer :user_id
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :redesigns
  end
end

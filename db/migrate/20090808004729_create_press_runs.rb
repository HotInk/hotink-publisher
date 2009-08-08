class CreatePressRuns < ActiveRecord::Migration
  def self.up
    create_table :press_runs do |t|
      t.integer :account_id
      t.integer :front_page_id
      t.integer :user_id
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :press_runs
  end
end

class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string "name"
      t.integer "account_id"
      t.datetime "date"
      t.text "bodytext"
      t.boolean  "status", :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end

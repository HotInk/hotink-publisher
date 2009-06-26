class AccountTable < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string   "name"
      t.string   "formal_name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "time_zone"
      t.text     "settings"
      t.integer       "account_resource_id"
    end
  end

  def self.down
    drop_table :accounts
  end
end
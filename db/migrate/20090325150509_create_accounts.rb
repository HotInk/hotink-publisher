class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.timestamps
      t.string "name"
      t.text   "preferences"
      t.text   "settings"
      t.integer "account_resource_id"
    end
  end

  def self.down
    drop_table :accounts
  end
end

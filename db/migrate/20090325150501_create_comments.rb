class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string   "email"
      t.string   "name"
      t.string   "url"
      t.text     "body"
      t.integer  "content_id"
      t.integer  "flags"
      t.integer  "account_id"
      t.string   "content_type"
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

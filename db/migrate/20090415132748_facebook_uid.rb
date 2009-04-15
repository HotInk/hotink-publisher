class FacebookUid < ActiveRecord::Migration
  def self.up
    add_column :comments, :fb_user_id, :integer
    add_column :comments, :email_hash, :string
  end

  def self.down
    remove_column :comments, :fb_user_id
    remove_column :comments, :email_hash
  end
end

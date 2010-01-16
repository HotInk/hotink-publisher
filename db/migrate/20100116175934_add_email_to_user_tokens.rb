class AddEmailToUserTokens < ActiveRecord::Migration
  def self.up
    add_column :user_tokens, :email, :string
  end

  def self.down
    remove_column :user_tokens, :email
  end
end

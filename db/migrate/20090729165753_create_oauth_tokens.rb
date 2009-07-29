class CreateOauthTokens < ActiveRecord::Migration
  def self.up
    create_table :oauth_tokens do |t|
      t.string :token, :null => false
      t.string :secret, :null => false
      t.string :token_type, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :oauth_tokens
  end
end

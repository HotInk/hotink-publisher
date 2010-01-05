class CreateUserTokens < ActiveRecord::Migration
  def self.up
    create_table :user_tokens do |t|
      t.string :token
      t.integer :user_id

      t.timestamps
    end
    add_index :user_tokens, :token
  end

  def self.down
    drop_table :user_tokens
  end
end

class CommentDisable < ActiveRecord::Migration
  def self.up
    add_column :comments, :enabled, :boolean
  end

  def self.down
    remove_column :comments, :enabled
  end
end

class CommentSpamFlag < ActiveRecord::Migration
  def self.up
      add_column :comments, :spam, :boolean
  end

  def self.down
    remove_column :comments, :spam
  end
end

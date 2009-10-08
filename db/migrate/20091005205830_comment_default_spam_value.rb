class CommentDefaultSpamValue < ActiveRecord::Migration
  def self.up
    change_column_default(:comments, :spam, false)
  end

  def self.down
  end
end

class AddDefaultCommentBooleans < ActiveRecord::Migration
  def self.up
    change_column_default(:comments, :flags, 0)
    change_column_default(:comments, :enabled, true)
  end

  def self.down
  end
end

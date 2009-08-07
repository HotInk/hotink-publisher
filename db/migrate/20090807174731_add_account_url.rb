class AddAccountUrl < ActiveRecord::Migration
  def self.up
    add_column :accounts, :url, :string
  end

  def self.down
    remove_column :accounts, :url
  end
end

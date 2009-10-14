class AddPublicToDesigns < ActiveRecord::Migration
  def self.up
    add_column :designs, :public, :boolean
    add_column :design_versions, :public, :boolean
  end

  def self.down
    remove_column :designs, :public
    remove_column :design_versions, :public
  end
end

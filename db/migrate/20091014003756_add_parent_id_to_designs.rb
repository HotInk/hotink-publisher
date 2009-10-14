class AddParentIdToDesigns < ActiveRecord::Migration
  def self.up
    add_column :designs, :parent_id, :integer
    add_column :design_versions, :parent_id, :integer
  end

  def self.down
    remove_column :designs, :parent_id
    remove_column :design_versions, :parent_id
  end
end

class AddLayoutIdToDesignsAndTemplates < ActiveRecord::Migration
  def self.up
    add_column :templates, :layout_id, :integer
    add_column :designs, :layout_id, :integer
  end

  def self.down
    remove_column :templates, :layout_id
    remove_column :designs, :layout_id
  end
end

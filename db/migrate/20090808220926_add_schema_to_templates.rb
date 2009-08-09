class AddSchemaToTemplates < ActiveRecord::Migration
  def self.up
    add_column :templates, :schema, :text
  end

  def self.down
    remove_column :templates, :schema, :text
  end
end

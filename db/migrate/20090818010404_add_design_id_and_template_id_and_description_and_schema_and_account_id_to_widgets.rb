class AddDesignIdAndTemplateIdAndDescriptionAndSchemaAndAccountIdToWidgets < ActiveRecord::Migration
  def self.up
    add_column :widgets, :design_id, :integer
    add_column :widgets, :template_id, :integer
    add_column :widgets, :description, :text
    add_column :widgets, :schema, :text
    add_column :widgets, :account_id, :integer
  end

  def self.down
    remove_column :widgets, :account_id
    remove_column :widgets, :schema
    remove_column :widgets, :description
    remove_column :widgets, :design_id
    remove_column :widgets, :template_id
  end
end

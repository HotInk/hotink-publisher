class AddVersionsToTemplatesAndTemplateFiles < ActiveRecord::Migration
  def self.up
    add_column :templates, :active, :boolean, :default => true
    add_column :template_files, :active, :boolean, :default => true
    Template.create_versioned_table
    TemplateFile.create_versioned_table
  end

  def self.down
    remove_column :templates, :active
    remove_column :template_files, :active
    Template.drop_versioned_table
    TemplateFile.drop_versioned_table 
  end
end

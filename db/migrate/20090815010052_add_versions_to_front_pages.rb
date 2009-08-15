class AddVersionsToFrontPages < ActiveRecord::Migration
  def self.up
    add_column :front_pages, :active, :boolean, :default => true
    add_column :designs, :active, :boolean, :default => true

    Design.create_versioned_table
    FrontPage.create_versioned_table
  end

  def self.down
    remove_column :front_pages, :active
    remove_column :designs, :active

    Design.drop_versioned_table    
    FrontPage.drop_versioned_table
  end
end

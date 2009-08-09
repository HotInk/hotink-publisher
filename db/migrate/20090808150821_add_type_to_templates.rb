class AddTypeToTemplates < ActiveRecord::Migration
  def self.up
    add_column :templates, :type, :string
  end

  def self.down
    remove_column :templates, :type
  end
end

class CreateTemplateFiles < ActiveRecord::Migration
  def self.up
    create_table :template_files do |t|
      t.integer :design_id
      t.string :type
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :template_files
  end
end

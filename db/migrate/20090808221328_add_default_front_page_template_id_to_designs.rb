class AddDefaultFrontPageTemplateIdToDesigns < ActiveRecord::Migration
  def self.up
    add_column :designs, :default_front_page_template_id, :integer
  end

  def self.down
    remove_column :designs, :default_front_page_template_id
  end
end

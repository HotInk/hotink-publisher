class CreateFrontPages < ActiveRecord::Migration
  def self.up
    create_table :front_pages, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.integer :account_id
      t.string :name
      t.text :description
      t.integer :template_id
      t.integer :design_id
      t.text :schema

      t.timestamps
    end
  end

  def self.down
    drop_table :front_pages
  end
end

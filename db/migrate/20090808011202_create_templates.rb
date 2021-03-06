class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.integer :design_id
      t.string :name
      t.text :description
      t.string :role
      t.text :code
      t.binary :parsed_code

      t.timestamps
    end
  end

  def self.down
    drop_table :templates
  end
end

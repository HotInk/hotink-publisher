class CreateDesigns < ActiveRecord::Migration
  def self.up
    create_table :designs do |t|
      t.integer :account_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :designs
  end
end

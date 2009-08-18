class CreateWidgetPlacements < ActiveRecord::Migration
  def self.up
    create_table :widget_placements do |t|
      t.integer :template_id
      t.integer :widget_id

      t.timestamps
    end
  end

  def self.down
    drop_table :widget_placements
  end
end

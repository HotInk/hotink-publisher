class CreatePodcasts < ActiveRecord::Migration
  def self.up
    create_table :podcasts do |t|
      t.string :category
      t.string :copyright
      t.string :title
      t.string :subtitle
      t.string :author_name
      t.string :author_email
      t.text :description
      t.integer :account_id
      t.integer :blog_id
      t.timestamps
    end
  end

  def self.down
    drop_table :podcasts
  end
end

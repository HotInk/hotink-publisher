class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer "article_resource_id"
      t.integer "account_id"
      t.integer "account_resource_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end

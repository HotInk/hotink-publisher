class CreateArticleOptions < ActiveRecord::Migration
  def self.up
    create_table :article_options do |t|
      t.timestamps
      t.boolean "comments_enabled"
      t.boolean "comments_locked"
      t.string "display_format"
      t.integer "article_id"
      t.integer "account_id"
    end
  end

  def self.down
    drop_table :article_options
  end
end

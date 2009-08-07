# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090807174731) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "formal_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.text     "settings"
    t.integer  "account_resource_id"
    t.string   "url"
  end

  create_table "article_options", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "comments_enabled"
    t.boolean  "comments_locked"
    t.string   "display_format"
    t.integer  "article_id"
    t.integer  "account_id"
  end

  create_table "comments", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "url"
    t.text     "body"
    t.integer  "content_id"
    t.integer  "flags"
    t.integer  "account_id"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fb_user_id"
    t.string   "email_hash"
    t.string   "type"
    t.boolean  "enabled"
  end

  create_table "oauth_tokens", :force => true do |t|
    t.string   "token",      :null => false
    t.string   "secret",     :null => false
    t.string   "token_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "date"
    t.text     "bodytext"
    t.boolean  "status",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "persistence_token",                 :null => false
    t.string   "oauth_token_id",                    :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

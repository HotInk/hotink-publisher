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

ActiveRecord::Schema.define(:version => 20090815010052) do

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

  create_table "design_versions", :force => true do |t|
    t.integer  "design_id"
    t.integer  "version"
    t.integer  "account_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "layout_id"
    t.integer  "default_front_page_template_id"
    t.boolean  "active",                         :default => true
  end

  add_index "design_versions", ["design_id"], :name => "index_design_versions_on_design_id"

  create_table "designs", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "layout_id"
    t.integer  "default_front_page_template_id"
    t.boolean  "active",                         :default => true
    t.integer  "version"
  end

  create_table "front_page_versions", :force => true do |t|
    t.integer  "front_page_id"
    t.integer  "version"
    t.integer  "account_id"
    t.string   "name"
    t.text     "description"
    t.integer  "template_id"
    t.integer  "design_id"
    t.text     "schema"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",        :default => true
  end

  add_index "front_page_versions", ["front_page_id"], :name => "index_front_page_versions_on_front_page_id"

  create_table "front_pages", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.text     "description"
    t.integer  "template_id"
    t.integer  "design_id"
    t.text     "schema"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      :default => true
    t.integer  "version"
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

  create_table "press_runs", :force => true do |t|
    t.integer  "account_id"
    t.integer  "front_page_id"
    t.integer  "user_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redesigns", :force => true do |t|
    t.integer  "account_id"
    t.integer  "design_id"
    t.integer  "user_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_file_versions", :force => true do |t|
    t.integer  "template_file_id"
    t.integer  "version"
    t.integer  "design_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",            :default => true
    t.string   "versioned_type"
  end

  add_index "template_file_versions", ["template_file_id"], :name => "index_template_file_versions_on_template_file_id"

  create_table "template_files", :force => true do |t|
    t.integer  "design_id"
    t.string   "type"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",            :default => true
    t.integer  "version"
  end

  create_table "template_versions", :force => true do |t|
    t.integer  "template_id"
    t.integer  "version"
    t.integer  "design_id"
    t.string   "name"
    t.text     "description"
    t.string   "role"
    t.text     "code"
    t.binary   "parsed_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "layout_id"
    t.text     "schema"
    t.boolean  "active",         :default => true
    t.string   "versioned_type"
  end

  add_index "template_versions", ["template_id"], :name => "index_template_versions_on_template_id"

  create_table "templates", :force => true do |t|
    t.integer  "design_id"
    t.string   "name"
    t.text     "description"
    t.string   "role"
    t.text     "code"
    t.binary   "parsed_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "layout_id"
    t.string   "type"
    t.text     "schema"
    t.boolean  "active",      :default => true
    t.integer  "version"
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

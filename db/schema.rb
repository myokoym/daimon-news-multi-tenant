# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151224093434) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "site_id"
    t.string   "slug",        null: false
    t.integer  "order",       null: false
  end

  add_index "categories", ["slug", "site_id"], name: "index_categories_on_slug_and_site_id", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "topic_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["topic_id"], name: "index_comments_on_topic_id", using: :btree

  create_table "fixed_pages", force: :cascade do |t|
    t.integer  "site_id",    null: false
    t.string   "title"
    t.text     "body"
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fixed_pages", ["site_id", "slug"], name: "index_fixed_pages_on_site_id_and_slug", unique: true, using: :btree

  create_table "hooks", force: :cascade do |t|
    t.integer  "site_id",    null: false
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hooks", ["token"], name: "index_hooks_on_token", unique: true, using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "image",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.string   "text"
    t.string   "url"
    t.integer  "order",      null: false
    t.integer  "site_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "links", ["site_id"], name: "index_links_on_site_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "site_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "published_at"
    t.integer  "category_id"
    t.string   "source_url"
    t.integer  "original_id"
    t.string   "thumbnail_url"
  end

  add_index "posts", ["site_id", "original_id"], name: "index_posts_on_site_id_and_original_id", unique: true, using: :btree
  add_index "posts", ["site_id"], name: "index_posts_on_site_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "name",                                       null: false
    t.string   "js_url",                                     null: false
    t.string   "css_url",                                    null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "fqdn",               default: "example.com", null: false
    t.string   "tagline"
    t.string   "copyright"
    t.boolean  "bbs_enabled",        default: false,         null: false
    t.string   "logo_url"
    t.string   "favicon_url"
    t.string   "mobile_favicon_url"
    t.string   "gtm_id"
    t.string   "content_header_url"
    t.string   "promotion_url"
    t.string   "sns_share_caption"
    t.string   "twitter_account"
    t.string   "ad_client"
    t.string   "ad_slot"
    t.string   "description"
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "site_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["site_id"], name: "index_topics_on_site_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "role",                   default: "user", null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "comments", "topics"
  add_foreign_key "fixed_pages", "sites"
  add_foreign_key "hooks", "sites"
  add_foreign_key "links", "sites"
  add_foreign_key "posts", "sites"
  add_foreign_key "topics", "sites"
end

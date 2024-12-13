# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_12_13_124455) do
  create_table "comment_liking_relations", force: :cascade do |t|
    t.integer "liking_user_id"
    t.integer "liked_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["liked_comment_id"], name: "index_comment_liking_relations_on_liked_comment_id"
    t.index ["liking_user_id", "liked_comment_id"], name: "index_liking_user_and_comment", unique: true
    t.index ["liking_user_id"], name: "index_comment_liking_relations_on_liking_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points", default: 0
    t.integer "parent_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "liking_relations", force: :cascade do |t|
    t.integer "liking_user_id"
    t.integer "liked_post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["liked_post_id"], name: "index_liking_relations_on_liked_post_id"
    t.index ["liking_user_id", "liked_post_id"], name: "index_liking_relations_on_liking_user_id_and_liked_post_id", unique: true
    t.index ["liking_user_id"], name: "index_liking_relations_on_liking_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "link"
    t.integer "points", default: 0
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_posts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
  end

  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "posts", "users"
end

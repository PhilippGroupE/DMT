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

ActiveRecord::Schema.define(version: 20180409105636) do

  create_table "alternatives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "decisionroom_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decisionroom_id"], name: "index_alternatives_on_decisionroom_id"
  end

  create_table "criterions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "decisionroom_id"
    t.string "name"
    t.string "description"
    t.float "weight", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decisionroom_id"], name: "index_criterions_on_decisionroom_id"
  end

  create_table "decisionrooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_decisionrooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "decisionroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decisionroom_id"], name: "index_user_decisionrooms_on_decisionroom_id"
    t.index ["user_id", "decisionroom_id"], name: "index_user_decisionrooms_on_user_id_and_decisionroom_id", unique: true
    t.index ["user_id"], name: "index_user_decisionrooms_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "decisionroom_id"
    t.bigint "alternative_id"
    t.bigint "criterion_id"
    t.float "value", limit: 24
    t.float "value_weighted", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_votes_on_alternative_id"
    t.index ["criterion_id"], name: "index_votes_on_criterion_id"
    t.index ["decisionroom_id"], name: "index_votes_on_decisionroom_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  create_table "votes_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float "sum", limit: 24
    t.bigint "decisionroom_id"
    t.bigint "user_id"
    t.bigint "alternative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_votes_results_on_alternative_id"
    t.index ["decisionroom_id"], name: "index_votes_results_on_decisionroom_id"
    t.index ["user_id"], name: "index_votes_results_on_user_id"
  end

  create_table "weighted_sums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "alternative_id"
    t.float "sum", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_weighted_sums_on_alternative_id"
    t.index ["user_id"], name: "index_weighted_sums_on_user_id"
  end

  add_foreign_key "alternatives", "decisionrooms"
  add_foreign_key "criterions", "decisionrooms"
  add_foreign_key "votes", "alternatives"
  add_foreign_key "votes", "criterions"
  add_foreign_key "votes", "decisionrooms"
  add_foreign_key "votes", "users"
  add_foreign_key "votes_results", "alternatives"
  add_foreign_key "votes_results", "decisionrooms"
  add_foreign_key "votes_results", "users"
  add_foreign_key "weighted_sums", "alternatives"
  add_foreign_key "weighted_sums", "users"
end

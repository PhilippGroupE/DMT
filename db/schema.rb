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

ActiveRecord::Schema.define(version: 20180519182733) do

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
    t.integer "position"
    t.index ["decisionroom_id"], name: "index_criterions_on_decisionroom_id"
  end

  create_table "decisionrooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.integer "creator_id"
    t.boolean "has_outcome"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_decisionrooms_on_token"
  end

  create_table "first_decision_analyses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "decisionroom_id"
    t.integer "usera_id"
    t.integer "userb_id"
    t.float "consens", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decisionroom_id"], name: "index_first_decision_analyses_on_decisionroom_id"
  end

  create_table "first_decision_analysis_group_consens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "decisionroom_id"
    t.float "group_consens", limit: 24
    t.float "rank", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decisionroom_id"], name: "index_first_decision_analysis_group_consens_on_decisionroom_id"
  end

  create_table "teamoutcome_sums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "decisionroom_id"
    t.bigint "alternative_id"
    t.float "outcome_sum", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_teamoutcome_sums_on_alternative_id"
    t.index ["decisionroom_id"], name: "index_teamoutcome_sums_on_decisionroom_id"
  end

  create_table "teamoutcomes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "alternative_id"
    t.bigint "criterion_id"
    t.bigint "decisionroom_id"
    t.float "average_value", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_teamoutcomes_on_alternative_id"
    t.index ["criterion_id"], name: "index_teamoutcomes_on_criterion_id"
    t.index ["decisionroom_id"], name: "index_teamoutcomes_on_decisionroom_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "email"
    t.bigint "decisionroom_id"
    t.boolean "has_voted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decisionroom_id"], name: "index_users_on_decisionroom_id"
    t.index ["name", "email", "decisionroom_id"], name: "index_users_on_name_and_email_and_decisionroom_id", unique: true
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

  create_table "weighted_sums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "alternative_id"
    t.float "value_weighted_sum", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_weighted_sums_on_alternative_id"
    t.index ["user_id"], name: "index_weighted_sums_on_user_id"
  end

  add_foreign_key "alternatives", "decisionrooms"
  add_foreign_key "criterions", "decisionrooms"
  add_foreign_key "teamoutcome_sums", "alternatives"
  add_foreign_key "teamoutcome_sums", "decisionrooms"
  add_foreign_key "votes", "alternatives"
  add_foreign_key "votes", "criterions"
  add_foreign_key "votes", "decisionrooms"
  add_foreign_key "votes", "users"
  add_foreign_key "weighted_sums", "alternatives"
  add_foreign_key "weighted_sums", "users"
end

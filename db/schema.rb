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

ActiveRecord::Schema.define(version: 20160619132131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arenas", force: :cascade do |t|
    t.string   "name",                    null: false
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
    t.string   "foreground_file_name"
    t.string   "foreground_content_type"
    t.integer  "foreground_file_size"
    t.datetime "foreground_updated_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "battles", force: :cascade do |t|
    t.json     "initiative", default: [], null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "prototypes", force: :cascade do |t|
    t.integer  "level",         limit: 2,  default: 1,     null: false
    t.integer  "experience",    limit: 2,  default: 35,    null: false
    t.string   "code",          limit: 60, default: "imp", null: false
    t.boolean  "big",                      default: false, null: false
    t.boolean  "leader",                   default: false, null: false
    t.boolean  "twice_attack",             default: false, null: false
    t.integer  "max_health",    limit: 2,  default: 50,    null: false
    t.integer  "max_armor",     limit: 2,  default: 0,     null: false
    t.integer  "immune",        limit: 2,  default: 0,     null: false
    t.integer  "resist",        limit: 2,  default: 0,     null: false
    t.integer  "initiative",    limit: 2,  default: 30,    null: false
    t.integer  "reach",         limit: 2,  default: 4,     null: false
    t.integer  "attack",        limit: 2,  default: 1,     null: false
    t.integer  "attack_2",      limit: 2
    t.integer  "accuracy",      limit: 2,  default: 80,    null: false
    t.integer  "accuracy_2",    limit: 2
    t.integer  "damage",        limit: 2,  default: 20,    null: false
    t.integer  "damage_2",      limit: 2
    t.integer  "source",        limit: 2,  default: 0,     null: false
    t.integer  "source_2",      limit: 2
    t.integer  "frames_count",  limit: 2,  default: 10,    null: false
    t.integer  "enroll_cost",   limit: 2,  default: 50,    null: false
    t.integer  "training_cost", limit: 2,  default: 5,     null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "units", force: :cascade do |t|
    t.integer  "battle_id",                              null: false
    t.integer  "prototype_id",                           null: false
    t.integer  "level",        limit: 2, default: 1,     null: false
    t.integer  "experience",   limit: 2, default: 35,    null: false
    t.integer  "health",       limit: 2, default: 50,    null: false
    t.integer  "health_max",   limit: 2, default: 50,    null: false
    t.integer  "armor",        limit: 2, default: 0,     null: false
    t.integer  "resist",       limit: 2, default: 0,     null: false
    t.integer  "initiative",   limit: 2, default: 30,    null: false
    t.integer  "accuracy",     limit: 2, default: 80,    null: false
    t.integer  "accuracy_2",   limit: 2
    t.integer  "damage",       limit: 2, default: 20,    null: false
    t.integer  "damage_2",     limit: 2
    t.boolean  "defend",                 default: false, null: false
    t.integer  "cell_num",     limit: 2, default: 1,     null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "units", ["battle_id"], name: "index_units_on_battle_id", using: :btree
  add_index "units", ["prototype_id"], name: "index_units_on_prototype_id", using: :btree

  add_foreign_key "units", "battles"
  add_foreign_key "units", "prototypes"
end

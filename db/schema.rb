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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121121055120) do

  create_table "effects", :force => true do |t|
    t.integer "unit_id"
    t.integer "e_type"
    t.integer "number"
    t.integer "time"
  end

  add_index "effects", ["unit_id"], :name => "index_effects_on_unit_id"

  create_table "game_logs", :force => true do |t|
    t.integer "game_id",                :null => false
    t.integer "round",   :default => 1
    t.integer "step",                   :null => false
    t.text    "action",                 :null => false
  end

  add_index "game_logs", ["game_id"], :name => "index_game_logs_on_game_id"

  create_table "games", :force => true do |t|
    t.integer  "map_id"
    t.integer  "player1_id",                      :null => false
    t.integer  "player2_id",                      :null => false
    t.integer  "player1_face",  :default => 0
    t.integer  "player2_face",  :default => 0
    t.integer  "rounds",        :default => 1
    t.integer  "scope1",        :default => 0
    t.integer  "scope2",        :default => 0
    t.integer  "cost_type",     :default => 0
    t.integer  "gold",          :default => 1000
    t.integer  "experience",    :default => 1000
    t.string   "initiative"
    t.integer  "current_round", :default => 0
    t.integer  "current_step",  :default => 0
    t.integer  "standoff",      :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "games", ["player1_id"], :name => "index_games_on_player1_id"
  add_index "games", ["player2_id"], :name => "index_games_on_player2_id"

  create_table "level_ups", :force => true do |t|
    t.integer "next_unit_id"
    t.integer "prev_unit_id"
    t.integer "acc_a",        :default => 0
    t.integer "acc_b",        :default => 1
    t.integer "acc2_a",       :default => 0
    t.integer "acc2_b",       :default => 0
    t.integer "armor_a",      :default => 0
    t.integer "armor_b",      :default => 0
    t.integer "dmg_a",        :default => 1
    t.integer "dmg_b",        :default => 2
    t.integer "dmg2_a",       :default => 0
    t.integer "dmg2_b",       :default => 0
    t.integer "exp_next_a",   :default => 0
    t.integer "exp_next_b",   :default => 0
    t.integer "hp_a",         :default => 5
    t.integer "hp_b",         :default => 5
  end

  add_index "level_ups", ["next_unit_id"], :name => "index_level_ups_on_next_unit_id"
  add_index "level_ups", ["prev_unit_id"], :name => "index_level_ups_on_prev_unit_id"

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.integer  "layer",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "prototypes", :force => true do |t|
    t.integer  "accuracy",      :default => 80
    t.integer  "accuracy_2"
    t.integer  "armor",         :default => 0
    t.integer  "reach",         :default => 4
    t.integer  "attack",        :default => 1
    t.integer  "attack_2"
    t.boolean  "big",           :default => false
    t.integer  "damage",        :default => 20
    t.integer  "damage_2"
    t.integer  "delay_a",       :default => 10
    t.integer  "experience",    :default => 35
    t.integer  "immune",        :default => 0
    t.integer  "resist",        :default => 0
    t.integer  "initiative",    :default => 30
    t.integer  "level",         :default => 1
    t.integer  "level_up_id",                      :null => false
    t.integer  "health",        :default => 50
    t.string   "name",          :default => "Бес"
    t.integer  "race",          :default => 6
    t.integer  "source",        :default => 0
    t.integer  "source_2"
    t.integer  "enroll_cost",   :default => 50
    t.integer  "training_cost", :default => 5
    t.boolean  "twice_attack",  :default => false
    t.integer  "add_num",       :default => 0
    t.boolean  "leader",        :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "prototypes", ["level_up_id"], :name => "index_prototypes_on_level_up_id"

  create_table "units", :force => true do |t|
    t.integer  "prototype_id",                    :null => false
    t.integer  "game_id",                         :null => false
    t.integer  "cell_num",     :default => 1
    t.integer  "health",       :default => 50
    t.integer  "accuracy",     :default => 80
    t.integer  "accuracy_2"
    t.integer  "armor",        :default => 0
    t.integer  "level",        :default => 1
    t.integer  "damage",       :default => 20
    t.integer  "damage_2"
    t.integer  "initiative",   :default => 30
    t.integer  "resist",       :default => 0
    t.boolean  "defend",       :default => false
    t.integer  "experience",   :default => 35
    t.integer  "health_max",   :default => 50
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "units", ["game_id"], :name => "index_units_on_game_id"
  add_index "units", ["prototype_id"], :name => "index_units_on_prototype_id"

  create_table "users", :force => true do |t|
    t.string   "username",                                          :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.integer  "role",                            :default => 0
    t.integer  "nev_id"
    t.boolean  "male",                            :default => true
    t.datetime "deleted_at"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end

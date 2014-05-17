# -*- encoding : utf-8 -*-
class CreateLevelUps < ActiveRecord::Migration
  def change
    create_table :level_ups do |t|
      t.references :next_unit
      t.references :prev_unit
      t.integer :acc_a       , :default => 0
      t.integer :acc_b       , :default => 1
      t.integer :acc2_a      , :default => 0
      t.integer :acc2_b      , :default => 0
      t.integer :armor_a     , :default => 0
      t.integer :armor_b     , :default => 0
      t.integer :dmg_a       , :default => 1
      t.integer :dmg_b       , :default => 2
      t.integer :dmg2_a      , :default => 0
      t.integer :dmg2_b      , :default => 0
      t.integer :exp_next_a  , :default => 0
      t.integer :exp_next_b  , :default => 0
      t.integer :hp_a        , :default => 5
      t.integer :hp_b        , :default => 5

      #t.timestamps
    end
    add_index :level_ups, :next_unit_id
    add_index :level_ups, :prev_unit_id
  end
end

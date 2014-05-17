# -*- encoding : utf-8 -*-
class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.references :prototype, :null => false
      t.references :game     , :null => false
      t.integer :cell_num    , :default => 1     # 1-12
      t.integer :health      , :default => 50
      t.integer :accuracy    , :default => 80
      t.integer :accuracy_2  , :default => nil
      t.integer :armor       , :default => 0
      t.integer :level       , :default => 1
      t.integer :damage      , :default => 20
      t.integer :damage_2    , :default => nil
      t.integer :initiative  , :default => 30
      t.integer :resist      , :default => 0     # 0b000000
      t.boolean :defend      , :default => false
      t.integer :experience  , :default => 35
      t.integer :health_max  , :default => 50

      t.timestamps
    end
    add_index :units, :prototype_id
    add_index :units, :game_id
  end
end

# -*- encoding : utf-8 -*-
class CreatePrototypes < ActiveRecord::Migration
  def change
    create_table :prototypes do |t|
      t.integer :accuracy     , :default => 80
      t.integer :accuracy_2   , :default => nil
      t.integer :armor        , :default => 0
      t.integer :reach        , :default => 4
      t.integer :attack       , :default => 1
      t.integer :attack_2     , :default => nil
      t.boolean :big          , :default => false
      t.integer :damage       , :default => 20
      t.integer :damage_2     , :default => nil
      t.integer :delay_a      , :default => 10     #[100 * number of frames] default = 1 second
      t.integer :experience   , :default => 35
      t.integer :immune       , :default => 0     # 0b000000
      t.integer :resist       , :default => 0     # 0b000000
      t.integer :initiative   , :default => 30
      t.integer :level        , :default => 1
      t.references :level_up  , :null    => false
      t.integer :health       , :default => 50
      t.string  :name         , :default => "Бес"
      t.integer :race         , :default => 6
      t.integer :source       , :default => 0
      t.integer :source_2     , :default => nil
      t.integer :enroll_cost  , :default => 50
      t.integer :training_cost, :default => 5     # за одну единицу опыта
      t.boolean :twice_attack , :default => false
      t.integer :add_num      , :default => 0     # дополнительное поле для вызова или оборота
      t.boolean :leader       , :default => false

      t.timestamps
    end
    add_index :prototypes, :level_up_id
  end
end

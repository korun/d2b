# -*- encoding : utf-8 -*-

class CreatePrototypes < ActiveRecord::Migration
  def change
    create_table :prototypes do |t|
      t.integer :level,         default: 1
      t.integer :experience,    default: 35
      t.integer :race,          default: 6

      t.boolean :big,           default: false
      t.boolean :leader,        default: false
      t.boolean :twice_attack,  default: false

      t.integer :max_health,    default: 50
      t.integer :max_armor,     default: 0
      t.integer :immune,        default: 0 # 0b000000
      t.integer :resist,        default: 0 # 0b000000

      t.integer :attack,        default: 1
      t.integer :attack_2,      default: nil
      t.integer :damage,        default: 20
      t.integer :damage_2,      default: nil
      t.integer :source,        default: 0
      t.integer :source_2,      default: nil
      t.integer :initiative,    default: 30
      t.integer :reach,         default: 4

      t.string  :code,          default: 'imp', limit: 60
      t.boolean :custom,        default: false # Определяет, что юнит пользовательский, и его нет в оригинальной игре
      t.integer :frames_count,  default: 10
      t.integer :enroll_cost,   default: 50 # цена найма
      t.integer :training_cost, default: 5  # за одну единицу опыта
    end
  end
end

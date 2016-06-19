class CreatePrototypes < ActiveRecord::Migration
  def change
    create_table :prototypes do |t|
      t.integer :level,         default: 1,        null: false, limit: 2
      t.integer :experience,    default: 35,       null: false, limit: 2
      t.string  :code,          default: 'imp',    null: false, limit: 60

      t.boolean :big,           default: false,    null: false
      t.boolean :leader,        default: false,    null: false
      t.boolean :twice_attack,  default: false,    null: false

      t.integer :max_health,    default: 50,       null: false, limit: 2
      t.integer :max_armor,     default: 0,        null: false, limit: 1
      t.integer :immune,        default: 0b000000, null: false, limit: 2
      t.integer :resist,        default: 0b000000, null: false, limit: 2
      t.integer :initiative,    default: 30,       null: false, limit: 1

      t.integer :reach,         default: 0b100,    null: false, limit: 1
      t.integer :attack,        default: 1,        null: false, limit: 2
      t.integer :attack_2,      default: nil,                   limit: 2
      t.integer :accuracy,      default: 80,       null: false, limit: 1
      t.integer :accuracy_2,    default: nil,                   limit: 2
      t.integer :damage,        default: 20,       null: false, limit: 2
      t.integer :damage_2,      default: nil,                   limit: 2
      t.integer :source,        default: 0,        null: false, limit: 1
      t.integer :source_2,      default: nil,                   limit: 1

      t.integer :frames_count,  default: 10,       null: false, limit: 1
      # Цена найма
      t.integer :enroll_cost,   default: 50,       null: false, limit: 2
      # За одну ед. опыта
      t.integer :training_cost, default: 5,        null: false, limit: 2

      t.timestamps null: false
    end
  end
end

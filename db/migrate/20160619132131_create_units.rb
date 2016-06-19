class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.references :prototype, null: false, index: true, foreign_key: true

      t.integer :level,      default: 1,        null: false, limit: 2
      t.integer :experience, default: 35,       null: false, limit: 2

      t.integer :health,     default: 50,       null: false, limit: 2
      t.integer :health_max, default: 50,       null: false, limit: 2
      t.integer :armor,      default: 0,        null: false, limit: 1
      t.integer :resist,     default: 0b000000, null: false, limit: 2
      t.integer :initiative, default: 30,       null: false, limit: 1

      t.integer :accuracy,   default: 80,       null: false, limit: 1
      t.integer :accuracy_2, default: nil,                   limit: 2
      t.integer :damage,     default: 20,       null: false, limit: 2
      t.integer :damage_2,   default: nil,                   limit: 2

      t.boolean :defend,     default: false,    null: false
      t.integer :cell_num,   default: 1,        null: false, limit: 1 # 1-12

      t.timestamps null: false
    end
  end
end

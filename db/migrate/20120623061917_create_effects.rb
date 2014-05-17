# -*- encoding : utf-8 -*-
class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.references :unit
      t.integer    :e_type
      t.integer    :number
      t.integer    :time

      #t.timestamps
    end
    add_index :effects, :unit_id
  end
end

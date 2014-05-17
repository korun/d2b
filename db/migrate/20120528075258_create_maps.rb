# -*- encoding : utf-8 -*-
class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string  :name                 # название
      t.integer :layer, :default => 0 # верхний слой (если есть)

      t.timestamps
    end
  end
end

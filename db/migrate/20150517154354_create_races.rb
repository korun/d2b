# -*- encoding : utf-8 -*-

class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string  :code,   null: false, limit: 40
      t.boolean :custom, default: false # Определяет, что раса пользовательская, и её нет в оригинальной игре
    end
  end
end

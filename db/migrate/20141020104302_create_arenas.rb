# -*- encoding : utf-8 -*-

class CreateArenas < ActiveRecord::Migration
  def change
    create_table :arenas do |t|
      t.string :name, :null => false
      t.attachment :background
      t.timestamps
    end
  end
end

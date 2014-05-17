# -*- encoding : utf-8 -*-
class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer    :map_id
      t.references :player1     ,  :null => false
      t.references :player2     ,  :null => false
      t.integer    :player1_face,  :default => 0
      t.integer    :player2_face,  :default => 0
      t.integer    :rounds      ,  :default => 1
      t.integer    :scope1      ,  :default => 0
      t.integer    :scope2      ,  :default => 0
      t.integer    :cost_type   ,  :default => 0
      t.integer    :gold        ,  :default => 1000
      t.integer    :experience  ,  :default => 1000
      t.string     :initiative
      t.integer    :current_round, :default => 0
      t.integer    :current_step,  :default => 0
      t.integer    :standoff    ,  :default => 0

      t.timestamps
    end
#   add_index :games, :map_id
    add_index :games, :player1_id
    add_index :games, :player2_id
  end
end

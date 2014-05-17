class CreateGameLogs < ActiveRecord::Migration
  def change
    create_table :game_logs do |t|
      t.references :game  , :null => false
      t.integer    :round , :default => 1
      t.integer    :step  , :null => false
      t.text       :action, :null => false
    end
    add_index :game_logs, :game_id
  end
end

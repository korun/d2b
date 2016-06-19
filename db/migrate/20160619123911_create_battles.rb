class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.json :initiative, default: [], null: false
      # t.integer :lock_version

      t.timestamps null: false
    end
  end
end

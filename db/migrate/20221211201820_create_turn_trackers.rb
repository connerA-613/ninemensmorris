class CreateTurnTrackers < ActiveRecord::Migration[6.1]
  def change
    create_table :turn_trackers do |t|
      t.belongs_to :game_master, index: {unique: true}, foreign_key: true
      t.integer :curr_player

      t.timestamps
    end
  end
end

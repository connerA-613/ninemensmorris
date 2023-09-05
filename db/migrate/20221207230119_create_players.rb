class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :colour
      t.integer :score
      t.belongs_to :game_master, foreign_key: true

      t.timestamps
    end
  end
end

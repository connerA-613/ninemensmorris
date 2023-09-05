class CreateGameMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :game_masters do |t|
      t.belongs_to :game_organiser, index: {unique: true}, foreign_key: true
      t.boolean :game_end

      t.timestamps
    end
  end
end

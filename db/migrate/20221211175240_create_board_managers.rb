class CreateBoardManagers < ActiveRecord::Migration[6.1]
  def change
    create_table :board_managers do |t|
      t.belongs_to :game_organiser, index: {unique: true}, foreign_key: true
      t.integer :source_location

      t.timestamps
    end
  end
end

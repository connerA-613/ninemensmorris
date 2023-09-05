class CreateContainers < ActiveRecord::Migration[6.1]
  def change
    create_table :containers do |t|
      t.belongs_to :player, foreign_key: true
      t.belongs_to :board_manager, index: {unique: true}, foreign_key: true
      t.timestamps
    end
  end
end

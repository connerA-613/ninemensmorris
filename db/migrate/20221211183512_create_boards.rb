class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.belongs_to :board_manager, index: {unique: true}, foreign_key: true
      t.belongs_to :rules_enforcer, index: {unique: true}, foreign_key: true

      t.timestamps
    end
  end
end

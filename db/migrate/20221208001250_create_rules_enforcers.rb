class CreateRulesEnforcers < ActiveRecord::Migration[6.1]
  def change
    create_table :rules_enforcers do |t|
      t.boolean :valid_mill
      t.boolean :valid_capture
      t.belongs_to :board_manager, index: {unique: true}, foreign_key: true

      t.timestamps
    end
  end
end

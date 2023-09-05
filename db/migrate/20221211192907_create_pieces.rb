class CreatePieces < ActiveRecord::Migration[6.1]
  def change
    create_table :pieces do |t|
      t.belongs_to :intersection_point, index: {unique: true}, foreign_key: true
      t.integer :container_id
      t.string :colour

      t.timestamps
    end
  end
end

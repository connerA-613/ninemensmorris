class CreateIntersectionPoints < ActiveRecord::Migration[6.1]
  def change
    create_table :intersection_points do |t|
      t.belongs_to :board, foreign_key: true
      t.integer :location
      t.boolean :can_be_moved_to, default: false

      t.timestamps
    end
  end
end

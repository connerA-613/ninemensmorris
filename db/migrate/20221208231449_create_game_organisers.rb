class CreateGameOrganisers < ActiveRecord::Migration[6.1]
  def change
    create_table :game_organisers do |t|
      t.integer :board_manager_id
      t.boolean :game_status

      t.timestamps
    end
  end
end

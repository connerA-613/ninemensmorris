class BoardController < ApplicationController
    def create
        game_id = params[:game_id]
        game_organiser = GameOrganiser.find game_id
        board_manager = BoardManager.create(game_organiser_id: game_organiser.id)

        game_organiser.board_manager_id = board_manager.id
        game_organiser.save()

        game_master = GameMaster.where(game_organiser_id: game_organiser.id).first

        # calls start game on game master
        game_master.game_status(true)

        # redirect to /game/:id
        redirect_to controller: "game", action: "show", id: game_organiser.id

        # make both players reload
        ActionCable.server.broadcast(
          "game",
          {
            lobby_number: game_organiser.id,
          }
        )
    end

    def show
      @source
    end

    def place
      board_id = params[:id]
      selected_position = params[:piece_id]
      board_manager = BoardManager.find(board_id)
      game_organiser = GameOrganiser.find_by(board_manager_id: board_manager.id)
      game_master = game_organiser.game_master
      turn_tracker = game_master.turn_tracker

      # throws error if invalid
      board_manager.place_piece(selected_position)

      # redirect to /game/:id
      redirect_to game_path(id: game_organiser.id)

      ActionCable.server.broadcast(
        "game",
        {
          lobby_number: game_organiser.id
        }
      )
      curr_player = game_master.get_turn
      if curr_player.get_colour == "black" && game_master.player.find_by(colour: "black").bag_empty?
        ActionCable.server.broadcast(
        "game",
        {
          lobby_number: game_organiser.id
        }
      )
      end
    end

    def capture
      destination = params[:button_id]
      game_id = params[:game_id]
      game_organiser = GameOrganiser.find game_id
      game_master = GameMaster.find_by(game_organiser_id, game_master.id)
      board_manager = BoardManager.find_by(game_organiser_id: game_organiser.id)
      board_manager.capture_piece(destination)




      if board_manager.game_won? == true
        redirect_to board_destory_path
      end
    end

    def move
      #TODO: game_end/destroy
      destination = params[:piece_id]
      game_id = params[:game_id]
      game_organiser = GameOrganiser.find game_id
      game_master = GameMaster.find_by(game_organiser_id: game_organiser.id)
      curr_turn = game_master.turn_tracker.get_current_player
      board_manager = BoardManager.find_by(game_organiser_id: game_organiser.id)
      board_manager.move_piece(destination)
      ActionCable.server.broadcast(
          "game",
          {
            lobby_number: game_organiser.id,
          }
        )
      board_manager.source_location = nil
    end

    def select()
      board_id = params[:id]
      selected_position = params[:piece_id]
      game_id = params[:game_id]
      game_organiser = GameOrganiser.find game_id
      board_manager = BoardManager.find_by(game_organiser_id: game_organiser.id)
      if board_manager.validate_source(selected_position) == true
        puts("source validated")
        @source = selected_position
      else
        #error handling for invalid selection
      end
      puts("moving to move path")
      ActionCable.server.broadcast(
        "game",
        {
          lobby_number: game_organiser.id
        }
      )
    end

    def destroy
        game_id = params[:game_id]
        game_organiser = GameOrganiser.find game_id
        board_manager = BoardManager.find_by(game_organiser_id: game_organiser.id)
        board_manager.destroy
        redirect_to results_path
    end
end

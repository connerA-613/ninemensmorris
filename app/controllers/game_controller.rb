class GameController < ApplicationController
  def new
  end

  def results
    @id = params[:id]
  end

  def create
    # create game organiser
    game_organiser = GameOrganiser.create

    # create game_master linked via foreign key to game_organiser
    game_master = game_organiser.create_game_master

    # redirect to /game/:id
    redirect_to action: "show", id: game_organiser.id
  end

  def show
    # validation
    if GameOrganiser.where(id: params[:id]).empty?
      redirect_to root_path, alert: "Game with this room code %d does not exist." % params[:id]
      return
    end

    # redirecting from join button
    if params[:commit] != nil
      # redirect to /game/:id
      redirect_to action: "show", id: params[:id]
    end

    @id = params[:id]
    game_organiser = GameOrganiser.find @id
    returning_player = session[:game_organiser] == game_organiser.id

    @in_lobby = BoardManager.where(game_organiser_id: params[:id]).empty?

    # BoardManager has not been created so we are still in the lobby
    if @in_lobby
      # allow user who was previously in game to rejoin without making new player
      if !returning_player
        game_organiser.join_game
        session[:game_organiser] = game_organiser.id

        ActionCable.server.broadcast(
          "lobby",
          {
            lobby_number: game_organiser.id,
          }
        )
      end

      # update reference to object since changes were made
      game_organiser = GameOrganiser.find @id
      @players = game_organiser.get_players

    # BoardManager has been created so we should show the board
    else
      @board = BoardManager.find_by(game_organiser_id: game_organiser.id)
      @positions = [
        "bottom:600px;left:5px;", "bottom:600px;left:300px;", "bottom:600px;left:595px;", "bottom:500px;left:105px;", "bottom:500px;left:300px;", "bottom:500px;left:497px;",
        "bottom:404px;left:202px;", "bottom:404px;left:299px;", "bottom:404px;left:398px;", "bottom:305px;left:5px;", "bottom:305px;left:105px;", "bottom:305px;left:202px;",
        "bottom:305px;left:398px;", "bottom:305px;left:497px;", "bottom:305px;left:595px;", "bottom:205px;left:202px;", "bottom:205px;left:299px;", "bottom:205px;left:398px;",
        "bottom:105px;left:105px;", "bottom:105px;left:300px;", "bottom:105px;left:497px;", "bottom:10px;left:5px;", "bottom:10px;left:300px;", "bottom:10px;left:595px;"
      ]
      @intersection_points = @board.board.intersection_point

      @current_player = game_organiser.game_master.get_turn

      white_player = game_organiser.get_players.find_by(colour: :white)
      black_player = game_organiser.get_players.find_by(colour: :black)

      @num_pieces_in_white_bag = white_player.bag.get_num_pieces
      @num_pieces_in_black_bag = black_player.bag.get_num_pieces

      @white_placed = 0
      @black_placed = 0
      @intersection_points.each do |point|
        if point.get_colour == "white"
          @white_placed += 1
        elsif point.get_colour == "black"
          @black_placed += 1
        end
      end

    end
  end

  def destroy
    game_id = params[:game_id]
    game_organiser = GameOrganiser.find game_id
    game_master = GameMaster.find_by(game_organiser_id: game_organiser.id)
    game_master.destroy
    redirect_to root_path
  end

end

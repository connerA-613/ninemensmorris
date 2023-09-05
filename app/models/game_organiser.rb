class GameOrganiser < ApplicationRecord
    has_one :game_master, dependent: :destroy

    def join_game
        # create player and add player to game_master
        colours = [:white, :black]
        game_master = self.game_master

        index = game_master.player.length
        player = Player.new(colour: colours[index%2])
        game_master.add_player(player)
    end

    def end_game(winner)
        if self.game_status == false
            return
        end

        self.game_status = false
        clean_up_board
    end

    def get_players
        game_master = self.game_master

        if game_master == nil
            return []
        end

        return game_master.player
    end

    private

    def set_up_board
    end

    def clean_up_board
        board = BoardManager.find(self.board_manager_id)
        board.clear()
    end

    # this is probably never used
    def set_up_players
        players = self.get_players
        players[0].name = "Player 1"
        players[1].name = "Player 2"
        players[0].save()
        players[1].save()

        gm = GameMaster.where(game_organiser_id: self.id)

        gm.add_player(players[0])
        gm.add_player(players[1])
    end
end

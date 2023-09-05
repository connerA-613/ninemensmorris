class GameMaster < ApplicationRecord
    has_many :player, dependent: :destroy
    has_one :turn_tracker, dependent: :destroy

    def game_status(active)
        if active
            start_game
        else
            end_game
        end
    end

    def add_player(player)
        num_players = self.player.length

        if num_players < 2
            player.game_master_id = self.id
            player.name = "Player" + (num_players + 1).to_s
            player.save()
        else
            raise "This lobby already has 2 players."
        end
    end

    def get_turn
        players = self.player
        current_turn_color = self.turn_tracker.get_current_player
        return players.find_by(colour: current_turn_color)
    end

    def end_turn(capture, opponent_valid_moves)
        # todo: update user scores and verify if game_won is called
        p_colour = self.turn_tracker.get_current_player
        if p_colour == "white"
            pl = self.player.find_by(colour: "black")
        else
            pl = self.player.find_by(colour: "white")
        end
        if capture == true
            pl.set_score = pl.set_score - 1
            pl.save()
        end
        if game_won(opponent_valid_moves) == false
            self.turn_tracker.next_turn()
        else
            game_status(false)
        end

    end

    private

    def start_game
        # todo: select starting player and set player scores to 9 and bags to default number of pieces
        players = self.player

        self.create_turn_tracker

        players.each do |player|
            player.set_score(9)
            bag = player.create_bag
            for _ in 1..9 do
                piece = Piece.new(colour: player.colour)
                player.bag.add_piece(piece)
            end

            if player.colour == "white"
                self.turn_tracker.curr_player = 1
                self.turn_tracker.save()
            end

            player.save()
        end

    end

    def game_won(opponent_valid_moves)
        # todo: add logic to check if game was won
        p_colour = self.turn_tracker.get_current_player
        if p_colour == "white"
            opp_piece_count = self.player.find_by(colour: "black").get_score
        else
            opp_piece_count = self.player.find_by(colour: "white").get_score
        end
        if opp_piece_count == 2
            return true
        elsif opponent_valid_moves == false
            return true
        else
            return false
        end
    end

    def end_game
        game_organiser = GameOrganiser.find_by(id: self.game_organiser_id)
        winner = get_winner()
        game_organiser.end_game(winner)
        self.game_end = true
        self.save()
    end

    def get_winner
        winner = self.turn_tracker.get_current_player
        return self.player.find_by(colour: winner)
    end
end

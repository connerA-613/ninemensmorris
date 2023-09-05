class BoardManager < ApplicationRecord
    has_one :board, dependent: :destroy
    has_one :graveyard, dependent: :destroy
    has_one :rules_enforcer, dependent: :destroy

    def initialize(*args, &block)
        super
        self.save()
        self.create_rules_enforcer
        self.create_board(rules_enforcer_id: rules_enforcer.id)
        self.create_graveyard
    end

    def clear
        self.board.clear
        self.graveyard.dump
        self.destroy
    end

    def place_piece(destination)
        game_organiser = GameOrganiser.find_by(board_manager_id: self.id)
        game_master = game_organiser.game_master
        current_player = game_master.get_turn
        game_state = self.board.get_state
        rules_enforcer = self.rules_enforcer

        valid_move = rules_enforcer.placement_valid?(destination)

        if valid_move == false
            raise "Invalid placement"
        end

        piece = current_player.get_piece

        intersection_point = game_state.find_by(location: destination)
        intersection_point.add_piece(piece)

        game_state = self.board.get_state

        game_master.turn_tracker.next_turn

        #TODO add this back in just figure out how to get opponent_next_moves: 
        #game_master.end_turn()

        # todo check for mills, need rules enforcer
    end

    def validate_source(source)
        game_organiser = GameOrganiser.find_by(board_manager_id: self.id)
        game_master = game_organiser.game_master
        current_player = game_master.get_turn
        point = self.board.intersection_point.find_by(location: source)
        if current_player.get_colour == point.get_colour
            self.update_attribute(:source_location, source)
            self.save()
            return true
        else
            return false
        end
    end

    def move_piece(destination)
        re = RulesEnforcer.find_by(board_manager_id: self.id)
        go = GameOrganiser.find_by(board_manager_id: self.id)
        gm = GameMaster.find_by(game_organiser_id: go.id)
        if re.move_valid?(self.source_location, destination) == true
            piece_to_move = self.board.remove_piece()
            self.board.update_intersection(source, piece_to_move, true)
            self.board.update_intersection(location, piece_to_move, false)
            if re.mill_created? == false
                gm.end_turn
                puts("ending turn")
            end
        else
            #error handling
        end
        @source = nil
    end

    def capture_piece(target)
        go = GameOrganiser.find_by(board_manager_id: self.id)
        re = RulesEnforcer.find_by(board_manager_id: self.id)
        curr_player = gm.get_turn
        mill = re.mill_created?
        points = self.board.get_state
        target_point self.board.intersection_point.find_by(location: target)
        coloured = coloured_piece?(target_point, curr_player.get_colour)
        if coloured == false
            if re.capture_valid?(points) == true
                removing = self.board.remove_piece(target)
                self.graveyard.add_piece(removing)
                points = self.board.get_state
                if curr_player.get_colour == "white"
                    valid_moves = re.has_valid_moves?(points, "black")
                else
                    valid_moves = re.has_valid_moves?(points, "white")
                end
                end_turn(true, valid_moves)
            else
                return false 
            end   
        else
            return false
        end    
    end

    def game_won?
        re = RulesEnforcer.find_by(board_manager_id: self.id)
        go = GameOrganiser.find_by(board_manager_id: self.id)
        gm = GameMaster.find_by(game_organiser_id: go.id)
        pl = gm.get_turn
        valid = re.has_valid_move?(pl.get_colour)
        if gm.game_won? == true
            return true
        else
            return false
        end
    end

    private

    def coloured_piece?(ip, colour)
        return True
    end

    def valid_location?(location)
        return location >= 0 && location <= 23
    end
end

class RulesEnforcer < ApplicationRecord
    # public methods

    # Summary: Calculates possible placement locations for a Piece in phase 1 given a list of all Intersection Points.
    # Returns: True if the destination IntersectionPoint is a valid placement location, false otherwise.
    # Parameters: Destination is a location index representing the IntersectionPoint to which a piece is to be placed at.
    def placement_valid?(destination)
        board = Board.find_by(board_manager_id: self.board_manager_id)

        if board.valid_location?(destination)
            return true
        else
            return false
        end

    end

    # Summary: Calculates possible movement locations for a Piece in phase 2 given a list of all IntersectionPoint.
    # Returns: True if the destination IntersectionPoint is a valid movement location, false otherwise.
    # Parameters: Source is a location index representing the IntersectionPoint from which a Piece is to be moved from. 
    # Destination is a location index representing the IntersectionPoint to which a Piece is to be moved to.
    def move_valid?(source, destination)
        board = Board.find_by(board_manager_id: board_manager_id)
        if board.valid_location?(destination)
            if source == 1
                if destination == 2 || destination == 10
                    return true
                else
                    return false
                end

            elsif source == 2
                if destination == 1 || destination == 3 || destination == 5
                    return true
                else
                    return false
                end

            elsif source == 3
                if destination == 2 || destination == 15
                    return true
                else
                    return false
                end

            elsif source == 4
                if destination == 11 || destination == 5
                    return true
                else
                    return false
                end

            elsif source == 5
                if destination == 2 || destination == 4 || destination == 8 || destination == 6
                    return true
                else
                    return false
                end

            elsif source == 6
                if destination == 5 || destination == 14
                    return true
                else
                    return false
                end

            elsif source == 7
                if destination == 12 || destination == 8
                    return true
                else
                    return false
                end

            elsif source == 8
                if destination == 5 || destination == 7 || destination == 9
                    return true
                else
                    return false
                end

            elsif source == 9
                if destination == 8 || destination == 13
                    return true
                else
                    return false
                end

            elsif source == 10
                if destination == 1 || destination == 11 || destination == 22
                    return true
                else
                    return false
                end

            elsif source == 11
                if destination == 10 || destination == 4 || destination == 12 || destination == 19
                    return true
                end

            elsif source == 12
                if destination == 11 || destination == 7 || destination == 16
                    return true
                else
                    return false
                end

            elsif source == 13
                if destination == 9 || destination == 14 || destination == 18
                    return true
                else
                    return false
                end

            elsif source == 14
                if destination == 13 || destination == 6 || destination == 15 || destination == 21
                    return true
                else
                    return false
                end

            elsif source == 15
                if destination == 3 || destination == 14 || destination == 24
                    return true
                else
                    return false
                end

            elsif source == 16
                if destination == 12 || destination == 17
                    return true
                else
                    return false
                end

            elsif source == 17
                if destination == 16 || destination == 18 || destination == 20
                    return true
                else
                    return false
                end

            elsif source == 18
                if destination == 17 || destination == 13
                    return true
                else
                    return false
                end

            elsif source == 19
                if destination == 11 || destination == 20
                    return true
                else
                    return false
                end

            elsif source == 20
                if destination == 19 || destination == 17 || destination == 21 || destination == 23
                    return true
                else
                    return false
                end

            elsif source == 21
                if destination == 20 || destination == 14
                    return true
                else
                    return false
                end

            elsif source == 22
                if destination == 10 || destination == 23
                    return true
                else
                    return false
                end

            elsif source == 23
                if destination == 22 || destination == 20 || destination == 24
                    return true
                else
                    return false
                end

            elsif source == 24
                if destination == 23 || destination == 15
                    return true
                else
                    return false
                end
            end
        else
            return false
        end

    end

    # Summary: Calculates whether a Piece can be captured from the specified Intersection Point.
    # Returns: True if the Piece capture is valid, false otherwise.
    # Parameters: Target is a location index representing the IntersectionPoint from which a Piece capture attempt is to take place.
    def capture_valid?(target)
        board = Board.find_by(board_manager_id: self.board_manager_id)
        target_point = board.intersection_point.find_by(location: target)
        go = GameOrganizer.find_by(board_manager_id, self.board_manager_id)
        gm = GameMaster.find_by(game_organiser_id, go.game_organiser_id)
        curr_player = gm.get_turn
        if target_point.empty? == false   
            if curr_player.get_colour != target_point.get_colour
                if self.mill_just_created?(target) == true
                    if self.capture_from_mill?(target) == true
                        return true
                    else
                        return false
                    end
                    return true
                end
            else
                return false
            end

        else
            return false
        end
    end

    # Summary: Queries for whether or not a mill has been created on the Board with the current move.
    # Returns: True if a mill has just been created, false otherwise.
    # Parameters: none.
    def mill_created?()
        board = Board.find_by(board_manager_id: self.board_manager_id)
        go = GameOrganizer.find_by(board_manager_id, self.board_manager_id)
        gm = GameMaster.find_by(game_organiser_id, go.game_organiser_id)
        curr_player = gm.get_turn
        for i in 1..24 do
            if board.intersection_point.find_by(location: i).get_colour == curr_player.get_colour
                if mill_just_created(i) == true
                    return true
                end
            end
        end
        return false
    end

    # Summary: Examine the Player scores to determine if the game has been won by a Player.
    # Returns: True if the game has been won, false otherwise.
    # Parameters: none.
#     def game_won?()

#         # go through the entire board and check if only 2 pieces remain for either colour

#         white_count = 0
#         black_count = 0

#         # how do I determine what each players colour is? 
#         # CURRENTLY SET TO "white" AND "black"

#         for i in 1..24 do

#             current_node = Board.where(board_manager_id: <board manager id>).grid[i]

#             if current_node.empty? == false

#                 if current_node.get_colour == :white 
#                     white_count+=1
#                 elsif current_node.get_colour == :black
#                     black_count+=1
#                 end 

#             end
#         end 
        
#         if black_count <= 2 || white_count <= 2 || self.has_valid_move?(:white) == false ||  self.has_valid_move?(:black) == false
#             return true
#         else
#             return false
#         end

#     end

#     # Summary: Examine the specified list of IntersectionPoints with the given Player colour to
#     # determine if that Player has any valid moves that they can play, if the game is in phase 2.
#     # Returns: True if valid moves exist, false otherwise.
#     # Parameters: Colour is the colour of the next Player who is to take their turn.
    def has_valid_move?(colour)
        board = Board.find_by(board_manager_id: self.board_manager_id)
        for i in 1..24 do

            source_node = board.intersection_point.find_by(location: i)

            for j in 1..24 do

                destination_node = board.intersection_point.find_by(location: j)

                if source_node.empty? == false && source_node.get_colour == colour && destination_node.empty?

                    if self.move_valid?(i,j)
                        return true
                    end
    
                end

            end

        end 

        return false

    end

#     # Summary: Check if a Piece capture is possible after a move has been played.
#     # Returns: True if a capture is possible, false otherwise.
#     # Parameters: Location is a location index representing the IntersectionPoint on the Board where a Piece was just moved to.
#     def can_capture?(location)

#         return self.mill_just_created?(location)

#     end

#     # private methods

#     # Summary: Check if a mill has been formed at the specified IntersectionPoint with the move that was just `played to see if a Piece capture is possible.
#     # Returns: True if a mill has just been formed, false otherwise.
#     # Parameters: Location is a location index representing the IntersectionPoint on the Board where a Piece was just moved to.`
    def mill_just_created?(location)

        board = Board.find_by(board_manager_id: self.board_manager_id)
        current_node = board.intersection_point.find_by(location: location)

        if location == 1
            if board.intersection_point.where(location: 2).get_colour == current_node.get_colour && board.intersection_point.where(location: 3).get_colour
                return true
            elsif board.intersection_point.where(location: 10).get_colour == current_node.get_colour && board.intersection_point.where(location: 22).get_colour
                return true
            end
        elsif location == 2
            if board.intersection_point.where(location: 1).get_colour == current_node.get_colour && board.intersection_point.where(location: 3).get_colour
                return true
            elsif board.intersection_point.where(location: 5).get_colour == current_node.get_colour && board.intersection_point.where(location: 8).get_colour
                return true
            end
        elsif location == 3
            if board.intersection_point.where(location: 1).get_colour == current_node.get_colour && board.intersection_point.where(location: 2).get_colour
                return true
            elsif board.intersection_point.where(location: 15).get_colour == current_node.get_colour && board.intersection_point.where(location: 24).get_colour
                return true
            end
        elsif location == 4
            if board.intersection_point.where(location: 5).get_colour == current_node.get_colour && board.intersection_point.where(location: 6).get_colour
                return true
            elsif board.intersection_point.where(location: 11).get_colour == current_node.get_colour && board.intersection_point.where(location: 19).get_colour
                return true
            end
        elsif location == 5
            if board.intersection_point.where(location: 4).get_colour == current_node.get_colour && board.intersection_point.where(location: 6).get_colour
                return true
            elsif board.intersection_point.where(location: 2).get_colour == current_node.get_colour && board.intersection_point.where(location: 8).get_colour
                return true
            end
        elsif location == 6
            if board.intersection_point.where(location: 4).get_colour == current_node.get_colour && board.intersection_point.where(location: 5).get_colour
                return true
            elsif board.intersection_point.where(location: 14).get_colour == current_node.get_colour && board.intersection_point.where(location: 21).get_colour
                return true
            end
        elsif location == 7
            if board.intersection_point.where(location: 8).get_colour == current_node.get_colour && board.intersection_point.where(location: 9).get_colour
                return true
            elsif board.intersection_point.where(location: 12).get_colour == current_node.get_colour && board.intersection_point.where(location: 16).get_colour
                return true
            end
        elsif location == 8
            if board.intersection_point.where(location: 7).get_colour == current_node.get_colour && board.intersection_point.where(location: 9).get_colour
                return true
            elsif board.intersection_point.where(location: 2).get_colour == current_node.get_colour && board.intersection_point.where(location: 5).get_colour
                return true
            end
        elsif location == 9
            if board.intersection_point.where(location: 7).get_colour == current_node.get_colour && board.intersection_point.where(location: 8).get_colour
                return true
            elsif board.intersection_point.where(location: 13).get_colour == current_node.get_colour && board.intersection_point.where(location: 18).get_colour
                return true
            end
        elsif location == 10
            if board.intersection_point.where(location: 1).get_colour == current_node.get_colour && board.intersection_point.where(location: 22).get_colour
                return true
            elsif board.intersection_point.where(location: 11).get_colour == current_node.get_colour && board.intersection_point.where(location: 12).get_colour
                return true
            end
        elsif location == 11
            if board.intersection_point.where(location: 10).get_colour == current_node.get_colour && board.intersection_point.where(location: 12).get_colour
                return true
            elsif board.intersection_point.where(location: 4).get_colour == current_node.get_colour && board.intersection_point.where(location: 19).get_colour
                return true
            end
        elsif location == 12
            if board.intersection_point.where(location: 10).get_colour == current_node.get_colour && board.intersection_point.where(location: 11).get_colour
                return true
            elsif board.intersection_point.where(location: 7).get_colour == current_node.get_colour && board.intersection_point.where(location: 16).get_colour
                return true
            end
        elsif location == 13
            if board.intersection_point.where(location: 9).get_colour == current_node.get_colour && board.intersection_point.where(location: 18).get_colour
                return true
            elsif board.intersection_point.where(location: 14).get_colour == current_node.get_colour && board.intersection_point.where(location: 15).get_colour
                return true
            end
        elsif location == 14
            if board.intersection_point.where(location: 13).get_colour == current_node.get_colour && board.intersection_point.where(location: 15).get_colour
                return true
            elsif board.intersection_point.where(location: 6).get_colour == current_node.get_colour && board.intersection_point.where(location: 21).get_colour
                return true
            end
        elsif location == 15
            if board.intersection_point.where(location: 3).get_colour == current_node.get_colour && board.intersection_point.where(location: 24).get_colour
                return true
            elsif board.intersection_point.where(location: 13).get_colour == current_node.get_colour && board.intersection_point.where(location: 14).get_colour
                return true
            end
        elsif location == 16
            if board.intersection_point.where(location: 7).get_colour == current_node.get_colour && board.intersection_point.where(location: 12).get_colour
                return true
            elsif board.intersection_point.where(location: 17).get_colour == current_node.get_colour && board.intersection_point.where(location: 18).get_colour
                return true
            end
        elsif location == 17
            if board.intersection_point.where(location: 16).get_colour == current_node.get_colour && board.intersection_point.where(location: 18).get_colour
                return true
            elsif board.intersection_point.where(location: 20).get_colour == current_node.get_colour && board.intersection_point.where(location: 23).get_colour
                return true
            end
        elsif location == 18
            if board.intersection_point.where(location: 16).get_colour == current_node.get_colour && board.intersection_point.where(location: 17).get_colour
                return true
            elsif board.intersection_point.where(location: 9).get_colour == current_node.get_colour && board.intersection_point.where(location: 13).get_colour
                return true
            end
        elsif location == 19
            if board.intersection_point.where(location: 4).get_colour == current_node.get_colour && board.intersection_point.where(location: 11).get_colour
                return true
            elsif board.intersection_point.where(location: 20).get_colour == current_node.get_colour && board.intersection_point.where(location: 21).get_colour
                return true
            end
        elsif location == 20
            if board.intersection_point.where(location: 19).get_colour == current_node.get_colour && board.intersection_point.where(location: 21).get_colour
                return true
            elsif board.intersection_point.where(location: 17).get_colour == current_node.get_colour && board.intersection_point.where(location: 23).get_colour
                return true
            end
        elsif location == 21
            if board.intersection_point.where(location: 19).get_colour == current_node.get_colour && board.intersection_point.where(location: 20).get_colour
                return true
            elsif board.intersection_point.where(location: 6).get_colour == current_node.get_colour && board.intersection_point.where(location: 14).get_colour
                return true
            end
        elsif location == 22
            if board.intersection_point.where(location: 1).get_colour == current_node.get_colour && board.intersection_point.where(location: 10).get_colour
                return true
            elsif board.intersection_point.where(location: 23).get_colour == current_node.get_colour && board.intersection_point.where(location: 24).get_colour
                return true
            end
        elsif location == 23
            if board.intersection_point.where(location: 22).get_colour == current_node.get_colour && board.intersection_point.where(location: 24).get_colour
                return true
            elsif board.intersection_point.where(location: 17).get_colour == current_node.get_colour && board.intersection_point.where(location: 20).get_colour
                return true
            end
        elsif location == 24
            if board.intersection_point.where(location: 22).get_colour == current_node.get_colour && board.intersection_point.where(location: 23).get_colour
                return true
            elsif board.intersection_point.where(location: 3).get_colour == current_node.get_colour && board.intersection_point.where(location: 15).get_colourr
                return true
            end
        end

        return false


    end

#     # Summary: Check if a Piece on the specified IntersectionPoint from an opponent’s mill can be captured.
#     # Returns: True if a piece can be removed from the mill that they are a part of, false otherwise.
#     # Parameters: Location is a location index representing the IntersectionPoint on the Board with the Piece to be captured.
    def capture_from_mill?(location)
        potential_mill = true
        board = Board.find_by(board_manager_id: self.board_manager_id)
        go = GameOrganizer.find_by(board_manager_id, self.board_manager_id)
        gm = GameMaster.find_by(game_organiser_id, go.game_organiser_id)
        curr_player = gm.get_turn
        if curr_player.get_colour == "white"
            opp_colour = "black"
        else
            opp_colour = "white"
        end

        if self.mill_just_created?(location)
            curr_mill = true
        else
            curr_mill = false
        end
        for i in 1..24 do
            if board.intersection_point.find_by(location: location).get_colour == opp_colour && mill_just_created?(i) == false
                potential_mill = false
            end
        end
        if curr_mill == true && potential_mill == true
            return true
        else
            return false
        end
    end
end
#     # Summary: Checks whether the given source location index is a valid IntersectionPoint to move a Piece from.
#     # Returns: True if the location is valid, false otherwise.
#     # Parameters: Source is the source IntersectionPoint a Piece is being moved from.
#     def source_valid?(source)

#         # not sure how this method will help
#         # need to check if the source location index has a piece with the same colour as current user?
#         # dont have current player colour

#         source_node = Board.where(board_manager_id: <board manager id>).grid[source]
#         if source_node.get_colour == colour
#             return true
#         else
#             return false
#         end

#     end



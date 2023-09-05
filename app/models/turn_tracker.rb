class TurnTracker < ApplicationRecord
    def get_current_player
        if self.curr_player == 1
            return :white
        elsif self.curr_player == 2
            return :black
        else
            return nil
        end
    end

    def next_turn
        if self.curr_player == 1
            self.curr_player = 2
        elsif self.curr_player == 2
            self.curr_player = 1
        end
        self.save
    end
end

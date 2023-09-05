class Player < ApplicationRecord
    has_one :bag, dependent: :destroy

    def get_name
        return self.name
    end

    def get_colour
        return self.colour
    end

    def get_piece
        piece = bag.remove_piece()
        piece
    end

    def get_score
        return self.score
    end

    def set_score(score)
        self.score = score
    end

    def bag_empty?
        if self.bag.empty? == true
            return true
        else
            return false
        end
    end

    def fill_bag(pieces)
        pieces.each {|p| self.bag.add_piece(p)}
    end
end

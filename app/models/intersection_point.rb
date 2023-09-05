class IntersectionPoint < ApplicationRecord
    has_one :piece, dependent: :destroy

    def get_point
        return self.location
    end

    def empty?
        if self.piece == nil
            return true 
        end
        return false
    end

    def get_colour
        piece = self.piece

        if piece == nil
            return nil
        end

        return piece.colour
    end

    def remove_piece
        piece = self.piece

        if piece != nil
            piece.intersection_point_id = nil
            piece.save()
        end
        self.moveable(true)
        return piece
    end

    def add_piece(piece)
        piece.intersection_point_id = self.id
        piece.save()
    end

    def moveable(flag)
        self.can_be_moved_to = flag
        self.save()
    end

end

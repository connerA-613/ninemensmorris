class Container < ApplicationRecord
    has_many :piece

    def add_piece(piece)
        piece.container_id = self.id
        piece.save()
    end

    def remove_piece
        piece = self.piece.last
        piece.container_id = nil
        piece.save()
        return piece
    end
    
    def dump
        self.piece.delete_all
    end

    def empty?()
        if self.piece.length == 0
            return true
        end

        return false
    end

    def size
        return self.piece.length
    end
end

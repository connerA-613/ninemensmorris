class Graveyard < Container

    def get_num_pieces(colour)
        return self.piece.where(colour: colour).length
    end
end
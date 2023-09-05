class Piece < ApplicationRecord
    def set_colour(colour)
        self.colour = colour
    end

    def get_colour()
        return self.colour
    end
end

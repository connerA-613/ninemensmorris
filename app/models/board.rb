class Board < ApplicationRecord
    has_many :intersection_point, dependent: :destroy

    def initialize(*args, &block)
        super
        self.save()
        for i in 1..24 do
            self.intersection_point.create(location: i)
        end
    end

    def clear
        for i in 1..24 do
            point_to_clear = self.intersection_point.find_by(location: i)
            point_to_clear.remove_piece
            point_to_clear.moveable(false)
        end
    end

    def empty?
        for i in 1..24 do
            point_to_check = self.intersection_point.find_by(location: i)
            if point_to_check.empty? == false
                return false
            end
        end
        return true
    end

    def valid_location?(new_location)
        puts("location")
        puts(new_location)
        point = self.intersection_point.find_by(location: new_location)
        if point.empty? == true
            return true
        else
            return false
        end
    end

    def update_intersection(location, piece, moveable)
        point_to_update = self.intersection_point.find_by(location: location)
        point_to_update.add_piece(piece)
        point_to_update.moveable(moveable)
    end

    def player_pieces(colour)
        count = 0
        for i in 1..24 do
            point_to_check = self.intersection_point.find_by(location: i)
            if point_to_check.get_colour == colour.to_s
                count += 1
            end
        end

        return count
    end

    def possible_moves(points)
        for i in points do
            point_to_set = self.intersection_point.find_by(location: i)
            point_to_set.moveable(true)
        end
    end

    def get_state
        return self.intersection_point
    end

    def remove_piece(location)
        return self.intersection_point.find_by(location: location).remove_piece
    end
end

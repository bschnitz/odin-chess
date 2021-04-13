# frozen_string_literal: true

# represents a queen on the chess board
class Queen < ChessPiece
  def move_range
    {
      diagonal: 8,
      orthogonal: 8
    }
  end
end

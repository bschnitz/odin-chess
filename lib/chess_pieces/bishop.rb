# frozen_string_literal: true

# represents a bishop on the chess board
class Bishop < ChessPiece
  def move_range
    {
      diagonal: 8,
      orthogonal: 0
    }
  end
end

# frozen_string_literal: true

# represents a rook on the chess board
class Rook < ChessPiece
  def move_range
    {
      diagonal: 0,
      orthogonal: 8
    }
  end

  def moved_over_positions_when_castling
    hr = @board.homerank(@color)
    kingside? ? [[5, hr], [6, hr]] : [[1, hr], [2, hr], [3, hr]]
  end

  def castling_fields_unoccupied?
    moved_over_positions_when_castling.all? do |position|
      !@board.piece_at?(position)
    end
  end
end

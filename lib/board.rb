# frozen_string_literal: true

# represents the Chess board, stores all pieces and their positions
class Board
  def initialize
    @pieces = []
    @history_of_moves = []
  end

  # captures any piece at position
  def capture_piece(position)
    find_piece(position)&.captured = true
  end

  def move_piece(piece, to)
    raise 'implement storing move in history'
    capture_piece(to)
    piece.position = to
  end

  def check?(color)
    raise 'not implemented yet'
  end

  def undo_latest_move_in_history
    raise 'not implemented yet'
  end

  def piece_at?(position, color)
    raise 'not implemented yet'
  end

  # checks if a piece of the specified color can be put on position,
  # disregarding if it is possible to actually move it there by any valid move
  def valid_field?(position, color)
    @board.on_board?(position) && !@board.has_piece?(position, color)
  end

  def find_piece(position)
    @pieces.find { |piece| piece.position == position }
  end
end

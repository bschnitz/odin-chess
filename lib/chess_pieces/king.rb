# frozen_string_literal: true

require_relative '../chess_piece'

# represents a king on the chess board
class King < ChessPiece
  def initialize(color, position, board)
    super(color, position, board)

    @castling_positions = {
      kingside: [6, @board.homerank(@color)],
      queenside: [2, @board.homerank(@color)]
    }
  end

  def move_range
    {
      diagonal: 1,
      orthogonal: 1
    }
  end

  def move_to?(position, board = @board, ignore_check: false)
    super(position, board, ignore_check: ignore_check) &&
      !board.king(opponent_color).in_range?(position)
  end

  def move_to(position, board = @board)
    rook = castling_rook(position)
    rook&.move_to(position, nil)
    @movement_history.push(position)
    board&.move_piece(self, position, rook: rook)
  end

  def in_range?(position)
    [1, -1, 0].repeated_permutation(2).include?(position)
  end

  def in_check?
    @board.under_attack?(position, opponent_color)
  end

  private

  # check whether this is a castling move and returns the correct rook
  def castling_rook(move_to_position)
    castling_side = @castling_positions.key([
      move_to_position[0],
      move_to_position[1]
    ])
    rooks_for_castling.find do |rook|
      rook.side == castling_side
    end
  end

  def rooks_for_castling
    # if a rook has been moved once, it can no longer be used for castling
    @board.get_rooks(@color).filter { |rook| !rook.moved? }
  end

  def moved_over_positions_when_castling(side)
    hr = @board.homerank(@color)
    side == :kingside ? [[5, hr], [6, hr]] : [[3, hr], [2, hr]]
  end

  def attacked_when_castling?(side)
    moved_over_positions_when_castling(side).any? do |position|
      @board.under_attack?(position, opponent_color)
    end
  end

  def possible_castling_positions
    # if the king has been moved once, castling is no longer possible
    return [] if moved?

    # The king is not currently in check.
    return [] if in_check?

    rooks_for_castling.filter_map do |rook|
      # There are no pieces between the king and the rook.
      next unless rook.castling_fields_unoccupied?

      # the king does not pass through a square that is attacked by an enemy
      # piece and will not end up in check
      next if attacked_when_castling?(rook.side)

      @castling_positions[rook.side]
    end
  end

  def reachable_positions
    super + [possible_castling_positions]
  end
end

# frozen_string_literal: true

require_relative '../chess_piece'

# represents a king on the chess board
class King < ChessPiece
  def initialize(color, position, board)
    super.initialize(color, position, board)

    home_rank = @color == :white ? 0 : 7
    @castling_positions = {
      kingside: { x: 2, y: home_rank },
      queenside: { x: 6, y: home_rank }
    }
  end

  def move_range
    {
      diagonal: 1,
      orthogonal: 1
    }
  end

  def move_to?(position, board = @board, ignore_check: false)
    super.move_to?(position, board, ignore_check: ignore_check) &&
      !board.king(opponent_color).in_range?(position)
  end

  def move_to(position, board = @board)
    rook = casteling_rook
    rook&.move_to(position, nil)
    @movement_history.push(position)
    board&.move_piece(self, position, rook)
  end

  def in_range?(position)
    [1, -1, 0].repeated_permutation(2).include?(position)
  end

  def in_check?
    @board.under_attack(position, opponent_color)
  end

  private

  def rooks_for_casteling
    # if a rook has been moved once, it can no longer be used for castling
    rooks = @board.get_rooks(@color).filter { |rook| !rook.moved? }

    rooks.map { |r| r.kingside ? [:kingside, r] : [:queenside, r] }.to_h
  end

  def moved_over_positions_when_casteling(side)
    hr = @board.homerank(@color)
    side == :kingside ? [[5, hr], [6, hr]] : [[3, hr], [2, hr]]
  end

  def attacked_when_casteling?(side)
    moved_over_positions_when_casteling(side).any? do |position|
      @board.under_attack(position, opponent_color)
    end
  end

  def possible_castling_positions
    # if the king has been moved once, castling is no longer possible
    return [] if moved?

    # The king is not currently in check.
    return [] if in_check?

    hr = @board.homerank(@color)
    rooks_for_casteling.filter_map do |side, rook|
      hr = @board.homerank(@color)

      # There are no pieces between the king and the rook.
      return false unless rook.move_to?(side == :kingside ? [5, hr] : [3, hr])

      # the king does not pass through a square that is attacked by an enemy
      # piece and will not end up in check
      return false if attacked_when_casteling?(side)

      @castling_positions[side]
    end
  end

  def reachable_positions
    super.reachable_positions + possible_castling_positions
  end
end

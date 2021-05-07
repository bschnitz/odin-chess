# frozen_string_literal: true

require_relative '../chess_piece'

# depicts a pawn on a chess board
class Pawn < ChessPiece
  def move_to(position, board = @board)
    @movement_history.push(position)
    board&.move_piece(
      self,
      position,
      pawn_double_move: double_move?(position),
      capture_at: en_passant_capture_position(position)
    )
  end

  def en_passant_capture_position(pos)
    [pos[0], pos[1] - move_delta] if attackable_by_en_passant?(position)
  end

  def self.start_row(color)
    color == :white ? 1 : 6
  end

  def self.create(color, x_pos, board)
    Pawn.new(color, [x_pos, Pawn.start_row(color)], board)
  end

  private

  def double_move?(position)
    position == [@position[0], @position[1] + move_delta]
  end

  def on_start_row?
    @position[1] == Pawn.start_row(@color)
  end

  def move_delta
    @color == :white ? 1 : -1
  end

  def attackable_positions
    attackable_positions = case [@position, move_delta]
      in [x, y], d then [[x - 1, y + d], [x + 1, y + d]]
    end
    attackable_positions.filter do |position|
      @board.piece_at(position) { |piece| piece.color == opponent_color } ||
        attackable_by_en_passant?(position)
    end
  end

  def attackable_by_en_passant?(position)
    @board.last[:pawn_double_move] &&
      @board.last[:moved_piece]&.color == opponent_color &&
      @board.last[:moved_piece]&.at?(position[0], position[1] - move_delta)
  end

  def reachable_positions_without_attack
    positions = []
    case [@position, move_delta]
      in [x, y], d
      unless @board.piece_at?([x, y + d])
        positions.push([x, y + d])
        on_start_row? && !@board.piece_at?([x, y + 2 * d]) &&
          positions.push([x, y + 2 * d])
      end
    end
    positions
  end

  def reachable_positions
    [attackable_positions, reachable_positions_without_attack]
  end
end

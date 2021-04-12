# frozen_string_literal: true

# base class of a chess piece. it provides an interface and implements basic
# functionalities, but every piece must implement it's specialities itself.
class ChessPiece
  attr_accessor :captured, :position

  def initialize(color, position, board)
    @board = board
    @position = position
    @color = color
    @captured = false
  end

  # check whether this piece can move to the specified position
  def move_to?(position, board = @board)
    in_range = positions_in_range.any? do |positions|
      positions.any? { |position_in_range| position_in_range == position }
    end

    # check whether the move would expose the own king to check
    move_to(position)
    can_move_to = in_range && !board.check?(@color)
    board.undo_latest_move_in_history

    can_move_to
  end

  # move this piece to the specified position (without validity check)
  def move_to(position, board = @board)
    board.move_piece(self, position)
  end

  def capture
    @captured = true
  end

  private

  # how many fields can this piece move diagonally and horizontally/vertically
  def move_range
    {
      diagonal: 0,
      orthogonal: 0 # not the best naming, since diagonals are also orthogonal
    }
  end

  def opponent_color(color = @color)
    color == :white ? :black : :white
  end

  def reachable(range, position = @position, &block)
    Enumerator.new do |yielder|
      loop do
        position = block.call(*position)

        break unless range.positive? && @board.valid_field?(position, @color)

        yielder << position
        range -= 1

        # opponent piece can be captured, but one cannot to move through them
        break if @board.piece_at?(position, opponent_color)
      end
    end
  end

  def diagonal_positions_in_range(range = move_range[:diagonal])
    return [] if range.zero?

    [[1, 1], [1, -1], [-1, -1], [-1, 1]].map do |delta|
      reachable(range) { |x, y| [x + delta[0], y + delta[1]] }.to_a
    end
  end

  def orthogonal_positions_in_range(range = move_range[:orthogonal])
    return [] if range.zero?

    [[1, 0], [-1, 0], [0, -1], [0, 1]].map do |delta|
      reachable(range) { |x, y| [x + delta[0], y + delta[1]] }.to_a
    end
  end

  def positions_in_range
    diagonal_positions_in_range + orthogonal_positions_in_range
  end
end

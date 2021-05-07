# frozen_string_literal: true

# base class of a chess piece. it provides an interface and implements basic
# functionalities, but every piece must implement it's specialities itself.
class ChessPiece
  attr_accessor :position
  attr_reader :color

  def initialize(color, position, board)
    @board = board
    @position = position
    @color = color
    @movement_history = [position]
  end

  def moved?
    @movement_history.length > 1
  end

  # check whether this piece can move to the specified position
  def move_to?(position, board = @board, ignore_check: false)
    in_range = reachable_positions.any? do |positions|
      positions.any? { |reachable_position| reachable_position == position }
    end

    unless ignore_check
      # check whether the move would expose the own king to check
      move_to(position)
      can_move_to = in_range && !board.check?(@color)
      board.undo_last_move
    end

    can_move_to
  end

  # move this piece to the specified position (without validity check)
  def move_to(position, board = @board)
    @movement_history.push(position)
    board&.move_piece(self, position)
  end

  def undo_last_move
    @position = @movement_history.pop
  end

  def kingside?
    @position[0] >= 4
  end

  def side
    @position[0] >= 4 ? :kingside : :queenside
  end

  def at?(position_x, position_y)
    @position[0] == position_x && @position[1] == position_y
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
    @board.opponent_color(color)
  end

  def reachable(range, position = @position, &block)
    Enumerator.new do |yielder|
      loop do
        position = block.call(*position)

        break unless range.positive? && @board.valid_field?(position, @color)

        yielder << position
        range -= 1

        # opponent piece can be captured, but one cannot to move through them
        break if @board.piece_at?(position) { |p| p.color == opponent_color }
      end
    end
  end

  def reachable_diagonal_positions(range = move_range[:diagonal])
    return [] if range.zero?

    [[1, 1], [1, -1], [-1, -1], [-1, 1]].map do |delta|
      reachable(range) { |x, y| [x + delta[0], y + delta[1]] }.to_a
    end
  end

  def reachable_orthogonal_positions(range = move_range[:orthogonal])
    return [] if range.zero?

    [[1, 0], [-1, 0], [0, -1], [0, 1]].map do |delta|
      reachable(range) { |x, y| [x + delta[0], y + delta[1]] }.to_a
    end
  end

  def reachable_positions
    reachable_diagonal_positions + reachable_orthogonal_positions
  end
end

# frozen_string_literal: true

require_relative 'chess_pieces/pawn'
require_relative 'chess_pieces/rook'
require_relative 'chess_pieces/knight'
require_relative 'chess_pieces/bishop'
require_relative 'chess_pieces/queen'
require_relative 'chess_pieces/king'

# represents the Chess board, stores all pieces and their positions
class Board
  attr_reader :max_rank, :max_column, :pieces

  X_START_POSITIONS = [
    [Rook,   [0, 7]],
    [Knight, [1, 6]],
    [Bishop, [2, 5]],
    [Queen,  [3]],
    [King,   [4]]
  ].freeze

  def initialize
    @pieces = []
    @captured = []
    @history = []
    @min_rank = 0
    @max_rank = 7
    @min_column = 0
    @max_column = 7
    @board_range_x = (@min_column..@max_column)
    @board_range_y = (@min_rank..@max_rank)
    setup_pieces
  end

  def add_piece(chess_piece_class, color, position)
    @pieces.push(chess_piece_class.new(color, position, self))
  end

  def setup_pieces
    [[@min_rank, :white], [@max_rank, :black]].each do |home_rank, color|
      (0..7).each { |x| @pieces.push(Pawn.create(color, x, self)) }
      X_START_POSITIONS.each do |piece_class, x_positions|
        x_positions.each do |x|
          @pieces.push(piece_class.new(color, [x, home_rank], self))
        end
      end
    end
  end

  # captures any piece at position, returns the captured piece
  def capture_piece(position)
    piece = piece_at(position)
    @captured.push(piece) if piece
    @pieces.delete(piece)
    piece
  end

  def move_piece(piece, to, rook: nil, pawn_double_move: false, capture_at: nil)
    captured_piece = capture_piece(capture_at || to)

    @history.push({
      moved_piece: piece,
      moved_rook: rook,
      captured_piece: captured_piece,
      pawn_double_move: pawn_double_move
    })

    piece.position = to
  end

  def undo_last_move
    last = history.pop
    last.moved_piece.undo_last_move
    last.moved_rook&.undo_last_move
    @pieces.push(@captured.pop) if last.captured_piece
  end

  def last
    history[-1]
  end

  def opponent_color(color)
    color == :white ? :black : :white
  end

  def under_attack?(position, attacker_color)
    @pieces
      .filter { |piece| piece.color == attacker_color }
      .any? { |piece| piece.move_to?(position, ignore_check: true) }
  end

  # is the king of color in check?
  def check?(color)
    king(color).in_check?
  end

  def king(color)
    @pieces.find { |piece| piece.is_a?(King) && piece.color == color }
  end

  def piece_at(position, &block)
    if block_given?
      @pieces.find { |piece| piece.at?(*position) && block.call }
    else
      @pieces.find { |piece| piece.at?(*position) }
    end
  end

  def piece_at?(position, &block)
    !piece_at(position, &block).nil?
  end

  def on_board?(position)
    @board_range_x.include(position[0]) && @board_range_y.include(position[1])
  end

  # all fields in range of the board, which do not have a piece of the same
  # color on it are valid
  def valid_field?(position, color)
    on_board?(position) && !piece_at?(position) { |p| p.color == color }
  end

  def get_rooks(color)
    @pieces.filter { |piece| piece.is_a?(Rook) && piece.color == color }
  end

  def homerank(color)
    color == :white ? @min_rank : @max_rank
  end
end

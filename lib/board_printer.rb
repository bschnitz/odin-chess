# frozen_string_literal: true

require 'matrix'

require_relative 'chess_pieces/pawn'
require_relative 'chess_pieces/rook'
require_relative 'chess_pieces/knight'
require_relative 'chess_pieces/bishop'
require_relative 'chess_pieces/queen'
require_relative 'chess_pieces/king'

# prints the chess board to console
class BoardPrinter
  SYMBOLS = {
    Pawn     => { white: '♙', black: '♟︎' },
    Rook     => { white: '♖', black: '♜' },
    Knight   => { white: '♘', black: '♞' },
    Bishop   => { white: '♗', black: '♝' },
    Queen    => { white: '♕', black: '♛' },
    King     => { white: '♔', black: '♚' },
    NilClass => { nil => ' ' }
  }.freeze

  def initialize(board)
    @board = board
  end

  def field_str(piece, row, col)
    bg = ((row + col) % 2).zero? ? '48;5;14' : '48;5;15'
    fg = '38;5;0'

    "\033[#{bg};#{fg}m#{SYMBOLS[piece.class][piece&.color]} "
  end

  def print
    puts "  #{('a '..'h ').to_a.join}"
    rows = indexed_board_matrix.row_vectors.map.with_index do |row, y|
      row.map.with_index { |piece, x| field_str(piece, y, x) }.to_a.join
    end

    # print from high to low index to have white at bottom of board
    rows.reverse_each.with_index { |row, i| puts "#{8-i} #{row}\033[0m #{8-i}" }
    puts "  #{('a '..'h ').to_a.join}"
  end

  def indexed_board_matrix
    num_rows = @board.max_rank + 1
    num_cols = @board.max_column + 1
    indexed_board = Matrix.build(num_rows, num_cols) { |_, _| nil }
    @board.pieces.each do |piece|
      x, y = piece.position
      indexed_board[y, x] = piece
    end
    indexed_board
  end
end

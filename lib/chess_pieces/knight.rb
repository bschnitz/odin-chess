# frozen_string_literal: true

require_relative '../chess_piece'

# depicts a knight on a chess board
class Knight < ChessPiece
  def reachable_positions
    deltas = [-1, 1, 2, -2].permutation(2).filter { |(a, b)| a != -b }
    [positions_from_deltas(deltas)]
  end
end

# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/chess_pieces/bishop'

describe Bishop do
  let(:board) do
    instance_double(
      Board,
      piece_at?: false,
      valid_field?: true,
      move_piece: nil,
      undo_last_move: nil,
      check?: false,
      under_attack?: false,
      opponent_color: :black,
      piece_at: nil
    )
  end

  context 'when at [d, 3] ([3, 2])' do
    subject { Bishop.new(:white, [3, 2], board) }

    it 'can move to [f, 1] (5, 0)' do
      expect(subject.move_to?([5, 0])).to eq true
    end

    it 'can move to [f, 5] (5, 4)' do
      expect(subject.move_to?([5, 4])).to eq true
    end

    it 'cannot move to [e, 5] (4, 4)' do
      expect(subject.move_to?([4, 4])).to eq false
    end
  end
end

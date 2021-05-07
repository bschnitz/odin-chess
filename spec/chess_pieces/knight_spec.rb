# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/chess_pieces/knight'

describe Knight do
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

  context 'when at [f, 3] ([5, 2])' do
    subject { Knight.new(:white, [5, 2], board) }

    it 'can move to [h, 4] (7, 3)' do
      expect(subject.move_to?([7, 3])).to eq true
    end

    it 'can move to [e, 1] (4, 0)' do
      expect(subject.move_to?([4, 0])).to eq true
    end

    it 'cannot move to [d, 3] (3, 2)' do
      expect(subject.move_to?([3, 2])).to eq false
    end
  end
end

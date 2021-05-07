# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/chess_pieces/pawn'

describe Pawn do
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

  subject { Pawn.new(:white, [4, 4], board) }

  describe '#move_to?' do
    let(:black_pawn) { Pawn.new(:black, [5, 4], board) }

    before do
      allow(board).to receive(:last).and_return({
        moved_piece: black_pawn,
        pawn_double_move: false
      })
    end

    context 'when en passant is possible (pawn with double move)' do
      it 'returns true for en passant move' do
        allow(board).to receive(:last).and_return({
          moved_piece: black_pawn,
          pawn_double_move: true
        })

        expect(subject.move_to?([5, 5])).to eq true
      end
    end

    context 'when en passant is not possible (pawn without double move)' do
      it 'returns false' do
        expect(subject.move_to?([5, 5])).to eq false
      end
    end

    context 'when double move is possible' do
      subject { Pawn.new(:white, [1, 1], board) }

      it 'returns true on double move' do
        expect(subject.move_to?([1, 3])).to eq true
      end
    end
  end
end

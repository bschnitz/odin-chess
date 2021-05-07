# frozen_string_literal: true

require_relative '../../lib/board'
require_relative '../../lib/chess_pieces/rook'
require_relative '../../lib/chess_pieces/king'

describe King do
  let(:board) do
    instance_double(
      Board,
      piece_at?: false,
      valid_field?: true,
      move_piece: nil,
      undo_last_move: nil,
      check?: false,
      under_attack?: false,
      homerank: 7
    )
  end

  let(:black_king)     { King.new(:black, [4, 7], board) }
  let(:rook_queenside) { Rook.new(:white, [0, 0], board) }
  let(:rook_kingside)  { Rook.new(:white, [7, 0], board) }

  context 'when castling' do
    before do
      allow(board)
        .to receive(:get_rooks)
        .with(:white).and_return([rook_queenside, rook_kingside])
      allow(board).to receive(:king).with(:black).and_return(black_king)
      allow(board).to receive(:homerank).with(:white).and_return(0)
      allow(board).to receive(:opponent_color).with(:white).and_return(:black)
    end

    # white king at e1
    subject { King.new(:white, [4, 0], board) }

    describe '#move_to?' do
      context 'when castling is possible' do
        it 'allows a castling move to queenside' do
          expect(subject.move_to?([2, 0])).to eq true
        end

        it 'allows a castling move to kingside' do
          expect(subject.move_to?([6, 0])).to eq true
        end
      end

      context 'when a field on kingside is under attack' do
        before do
          allow(board)
            .to receive(:under_attack?)
            .with([5, 0], :black)
            .and_return(true)
        end

        it 'allows a castling move to queenside' do
          expect(subject.move_to?([2, 0])).to eq true
        end

        it 'disallows castling move to kingside' do
          expect(subject.move_to?([6, 0])).to eq false
        end
      end

      context 'when a piece is standing next to king on queenside' do
        before do
          allow(board)
            .to receive(:piece_at?)
            .with([3, 0])
            .and_return(true)
        end

        it 'allows a castling move to kingside' do
          expect(subject.move_to?([6, 0])).to eq true
        end

        it 'disallows castling move to queenside' do
          expect(subject.move_to?([2, 0])).to eq false
        end
      end

      context 'when the rook on kingside has moved already' do
        before do allow(rook_kingside).to receive(:moved?).and_return(true)
        end

        it 'disallows a castling move to kingside' do
          expect(subject.move_to?([6, 0])).to eq false
        end

        it 'allows castling move to queenside' do
          expect(subject.move_to?([2, 0])).to eq true
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/chess_piece'

describe ChessPiece do
  let(:board) do
    instance_double(
      Board,
      piece_at?: false,
      valid_field?: true,
      move_piece: nil,
      undo_last_move: nil,
      check?: false
    )
  end

  # white piece at c4
  subject { ChessPiece.new(:white, [2, 3], board) }

  context 'when some diagonal fields are blocked for movement' do
    before do
      [[-1, 0], [5, 6], [4, -1], [1, 4]].each do |position|
        allow(board).to receive(:valid_field?)
          .with(position, :white)
          .and_return(false)
      end
      allow(subject)
        .to receive(:move_range)
        .and_return({ diagonal: 8, orthogonal: 0 })
    end

    describe '#move_to?' do
      context 'when piece can move diagonally' do
        it 'can move to [0, 1]' do
          expect(subject.move_to?([0, 1])).to be true
        end

        it 'can move to [4, 5]' do
          expect(subject.move_to?([4, 5])).to be true
        end

        it 'can move to [4, 1]' do
          expect(subject.move_to?([4, 1])).to be true
        end

        it 'cannot move outside borders' do
          expect(subject.move_to?([-1, 0])).to be false
        end

        it 'cannot move horizontally' do
          expect(subject.move_to?([4, 3])).to be false
        end

        it 'cannot move vertically' do
          expect(subject.move_to?([2, 6])).to be false
        end

        it 'cannot move arbitrary' do
          expect(subject.move_to?([2, 6])).to be false
        end
      end
    end
  end
end

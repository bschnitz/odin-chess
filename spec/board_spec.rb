# frozen_string_literal: true

require_relative '../lib/board'

require_relative '../lib/chess_pieces/pawn'
require_relative '../lib/chess_pieces/rook'
require_relative '../lib/chess_pieces/queen'
require_relative '../lib/chess_pieces/king'

describe Board do
  context 'when set up' do
    it 'has a white pawn at [4, 1]' do
      expect(subject.piece_at([4, 1]).color).to eq(:white)
      expect(subject.piece_at([4, 1])).to be_instance_of(Pawn)
    end

    it 'has a black rook at [0, 7]' do
      expect(subject.piece_at([0, 7]).color).to eq(:black)
      expect(subject.piece_at([0, 7])).to be_instance_of(Rook)
    end

    it 'has a white queen at [3, 0]' do
      expect(subject.piece_at([3, 0]).color).to eq(:white)
      expect(subject.piece_at([3, 0])).to be_instance_of(Queen)
    end

    it 'has a black king at [4, 7]' do
      expect(subject.piece_at([4, 7]).color).to eq(:black)
      expect(subject.piece_at([4, 7])).to be_instance_of(King)
    end
  end
end

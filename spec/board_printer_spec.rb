# frozen_string_literal: true

require_relative 'fixtures'
require_relative '../lib/board'
require_relative '../lib/board_printer'

describe BoardPrinter do
  let(:board) { Board.new }
  subject { BoardPrinter.new(board) }

  it 'prints the board correctly after setup' do
    expect { subject.print }
      .to output(Fixtures.read('new_game_board.txt'))
      .to_stdout
  end
end

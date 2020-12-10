# frozen_string_literal: true

require './lib/board'
require './lib/chess_set'

describe Board do
  describe '#make_board' do
    it 'creates an array 8x8' do
      play = Board.new
      expect(play.make_board).to eql(
        [[nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil]]
      )
    end
  end
end

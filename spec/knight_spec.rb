# frozen_string_literal: true

require './lib/board'
require './lib/movement'
require './lib/pieces/knight'

describe Knight do
  def setup
    play = Board.new
    play.board.flatten.each do |e|
      return e if e.id == 'blk_kht_1'
    end
  end

  describe '#available_moves' do
    it 'checks to see what legal moves the knight has' do
      knight = setup
      expect(knight.available_moves).to eql([[2, 2], [2, 0], [1, 3]])
    end
  end

  describe '#moves' do
    it 'creates a new node in the knight move_tree' do
      knight = setup
      expect(knight.moves([2, 2])).to be_an_instance_of(Node)
    end
  end
end

# frozen_string_literal: true

require './lib/board'
require './lib/movement'
require './lib/pieces/pawn'

describe Pawn do
  def setup(id)
    play = Board.new
    play.board.flatten.each do |e|
      return e if e.id == id
    end
  end

  describe '#available_moves' do
    it 'allows the pawn to move two spaces if its the pawns first move' do
      pawn = setup('blk_pwn_1')
      expect(pawn.available_moves).to eql([[2, 0], [2, 1], [3, 0]])
    end
  end

  describe '#moves' do
    it 'creates a new node in the pawn move_tree' do
      pawn = setup('blk_pwn_1')
      expect(pawn.moves([2, 0])).to be_an_instance_of(Node)
    end

    it 'creates a new node in the pawn move_tree for first turn move' do
      pawn = setup('blk_pwn_1')
      expect(pawn.moves([3, 0])).to be_an_instance_of(Node)
    end
  end
end

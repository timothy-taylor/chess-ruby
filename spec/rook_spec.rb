require './lib/board.rb'
require './lib/movement.rb'
require './lib/pieces/rook.rb'

describe Rook do
  describe "#available_moves" do
    it "checks to see what legal moves the rook has" do
      play = Board.new
      black = play.create_black_side
      rook = black.create_rook("blk_rok_1")
      expect(rook.available_moves).to eql(
        [[1, 0], [0, 1], [2, 0], [0, 2], [3, 0], [0, 3], [4, 0],
         [0, 4], [5, 0], [0, 5], [6, 0], [0, 6], [7, 0], [0, 7]])
    end
  end

  describe "#moves" do
    it "creates a new node in the knight move_tree" do
      play = Board.new
      black = play.create_black_side
      rook = black.create_rook("blk_rok_1")
      expect(rook.moves([2, 2])).to be_an_instance_of(Node)
    end
  end
end


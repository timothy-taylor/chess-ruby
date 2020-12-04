require './lib/board.rb'
require './lib/movement.rb'
require './lib/pieces/knight.rb'

describe Knight do
  describe "#available_moves" do
    it "checks to see what legal moves the knight has" do
      play = Board.new
      black = play.create_black_side
      knight = black.create_knight("blk_kht_1")
      expect(knight.available_moves).to eql([[2, 2], [2, 0], [1, 3]])
    end
  end

  describe "#moves" do
    it "creates a new node in the knight move_tree" do
      play = Board.new
      black = play.create_black_side
      knight = black.create_knight("blk_kht_1")
      expect(knight.moves([2, 2])).to be_an_instance_of(Node)
    end
  end
end


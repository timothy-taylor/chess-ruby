require './lib/board.rb'
require './lib/movement.rb'
require './lib/pieces/bishop.rb'

describe Bishop do
  describe "#available_moves" do
    it "checks to see what legal moves the bishop has" do
      play = Board.new
      black = play.create_black_side
      bishop = black.create_bishop("blk_bsh_1")
      expect(bishop.available_moves).to eql(
        [[1, 3], [2, 4], [3, 5], [4, 6], [5, 7], [6, 8]])
    end
  end

 # describe "#moves" do
 #   it "creates a new node in the bishop move_tree" do
 #     play = Board.new
 #     black = play.create_black_side
 #     bishop = black.create_bishop("blk_bsh_1")
 #     expect(bishop.moves([0, 4])).to be_an_instance_of(Node)
 #   end
 # end
end


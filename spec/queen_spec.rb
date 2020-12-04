require './lib/board.rb'
require './lib/movement.rb'
require './lib/pieces/queen.rb'

describe Queen do
  describe "#available_moves" do
    it "checks to see what legal moves the queen has" do
      play = Board.new
      black = play.create_black_side
      queen = black.create_queen("blk_que_1")
      expect(queen.available_moves).to eql(
        [[1, 3], [0, 4], [1, 4], [2, 3], [0, 5], [2, 5],
         [3, 3], [0, 6], [3, 6], [4, 3], [0, 7], [4, 7],
         [5, 3], [0, 8], [5, 8], [6, 3], [7, 3]])   
    end
  end

  describe "#moves" do
    it "creates a new node in the queen move_tree" do
      play = Board.new
      black = play.create_black_side
      queen = black.create_queen("blk_que_1")
      expect(queen.moves([0, 5])).to be_an_instance_of(Node)
    end
  end
end


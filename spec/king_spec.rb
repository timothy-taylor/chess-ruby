require './lib/board.rb'
require './lib/movement.rb'
require './lib/pieces/king.rb'

describe King do
  def set_up
   play = Board.new
   black = play.create_black_side
   black.create_piece("blk_kng_1", King)
  end

  describe "#available_moves" do
    it "checks to see what legal moves the king has" do
      king = set_up  
      expect(king.available_moves).to eql(
        [[1, 4], [1, 5], [0, 5], [0, 3], [1, 3]])
    end
  end

  describe "#moves" do
    it "creates a new node in the queen move_tree" do
      king = set_up
      expect(king.moves([0, 5])).to be_an_instance_of(Node)
    end
  end
end


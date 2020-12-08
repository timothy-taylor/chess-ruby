require './lib/board.rb'
require './lib/movement.rb'
require './lib/pieces/bishop.rb'

describe Bishop do
  def set_up
    play = Board.new
    play.board.flatten.each { |e| 
      return e if e.id == "blk_bsh_1" 
    }
  end

  describe "#available_moves" do
    it "checks to see what legal moves the bishop has" do
      bishop = set_up    
      expect(bishop.available_moves).to eql(
        [[1, 3], [2, 4], [3, 5], [4, 6], [5, 7], [6, 8]])
    end
  end

  describe "#moves" do
    it "creates a new node in the bishop move_tree" do
      bishop = set_up 
      expect(bishop.moves([1, 3])).to be_an_instance_of(Node)
    end
  end
end


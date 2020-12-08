require './lib/board.rb'
require './lib/movement.rb'
require './lib/pieces/knight.rb'

describe Knight do
  def set_up
    play = Board.new
    play.board.flatten.each { |e|
     return e if e.id == "blk_kht_1"
    }
  end

  describe "#available_moves" do
    it "checks to see what legal moves the knight has" do
      knight = set_up    
      expect(knight.available_moves).to eql([[2, 2], [2, 0], [1, 3]])
    end
  end

  describe "#moves" do
    it "creates a new node in the knight move_tree" do
      knight = set_up
      expect(knight.moves([2, 2])).to be_an_instance_of(Node)
    end
  end
end


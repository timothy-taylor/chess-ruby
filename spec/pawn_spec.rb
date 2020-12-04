require './lib/board.rb'
require './lib/movement.rb'
require './lib/pieces/pawn.rb'


describe Pawn do
  def set_up(id)
    play = Board.new
    black = play.create_black_side
    black.create_pawn(id)
  end

  describe "#available_moves" do
    it "allows the pawn to move two spaces if its the pawns first move" do
      pawn = set_up("blk_pwn_1")
      expect(pawn.available_moves).to eql([[2, 0], [3, 0]])
    end
  end

  describe "#moves" do
    it "creates a new node in the pawn move_tree" do
      pawn = set_up("blk_pwn_1") 
      expect(pawn.moves([3, 0])).to be_an_instance_of(Node)
    end
  end
end


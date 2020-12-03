require './lib/board.rb'
require './lib/chess_set.rb'

describe Board do
  describe "#make_board" do
    it "creates an array 8x8" do
      play = Board.new
      expect(play.make_board).to eql(
        [[nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil]])
    end
  end

#  describe "#initialize" do
#    it "puts all necessary pieces into starting positions" do
#      play = Board.new
#      expect(play.board).to eql(
#        [["♖", "♘", "♗", "♕", "♔", "♗", "♘", "♖"],
#         ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"],
#         [nil, nil, nil, nil, nil, nil, nil, nil],
#         [nil, nil, nil, nil, nil, nil, nil, nil],
#         [nil, nil, nil, nil, nil, nil, nil, nil],
#         [nil, nil, nil, nil, nil, nil, nil, nil],
#         ["♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎"],
#         ["♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜"]])
#    end
#  end
end

describe BlackSide do
  describe "#create_knight" do
    it "creates the knight object and places its symbol in the array" do
      play = Board.new
      play.black.create_knight(self, "blk_kht_1")
      play.black.create_knight(self, "blk_kht_2")
      expect(play.board).to eql(
        [[nil, "♘", nil, nil, nil, nil, "♘", nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil]])
    end
  end
end

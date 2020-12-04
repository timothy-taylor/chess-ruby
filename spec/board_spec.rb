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

  describe "#print_board" do
    it "replaces nil values with squares" do
      play = Board.new
      expect(play.print_board).to eql(
        [["□", "■", "□", "■", "□", "■", "□", "■"],
         ["■", "□", "■", "□", "■", "□", "■", "□"],
         ["□", "■", "□", "■", "□", "■", "□", "■"],
         ["■", "□", "■", "□", "■", "□", "■", "□"],
         ["□", "■", "□", "■", "□", "■", "□", "■"],
         ["■", "□", "■", "□", "■", "□", "■", "□"],
         ["□", "■", "□", "■", "□", "■", "□", "■"],
         ["■", "□", "■", "□", "■", "□", "■", "□"]])
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
  describe "#create_pieces" do
    it "creates the pieces and places symbols in the array" do
      play = Board.new
      play.black.create_pieces
      expect(play.board).to eql(
        [["♖", "♘", "♗", nil, nil, "♗", "♘", "♖"],
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

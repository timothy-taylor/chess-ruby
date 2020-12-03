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

  describe "#place_piece" do
    it "puts the correct piece into its starting position in the array" do
      play = Board.new
      play.make_board
      play.place_piece("blk_kht_1")
      expect(play.board).to eql(
        [[nil, "♞", nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil]])

    end
  end

  describe "#create_black_side" do
    it "creates all necessary black pieces" do
      play = Board.new
      play.make_board
      play.create_black_side
      expect(play.board).to eql(
        [["♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜"],
         ["♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎"],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil]])
    end
  end

  describe "#create_white_side" do
    it "creates all necessary white pieces" do
      play = Board.new
      play.make_board
      play.create_white_side
      expect(play.board).to eql(
        [[nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"],
         ["♖", "♘", "♗", "♕", "♔", "♗", "♘", "♖"]])
    end
  end
end

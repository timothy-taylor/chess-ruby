require './lib/board.rb'

describe Board do
  describe "#initialize" do
    it "creates an array 8x8" do
      play = Board.new
      expect(play.board).to eql([ [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil] ])
    end

    it "creates an empty hash for utility operations" do
      play = Board.new
      expect(play.working_hash).to eql({})
    end
  end

  describe "#create_black_side" do
    it "creates two black knights and puts them in the working hash" do
      play = Board.new
      black = play.create_black_side
      black.create_knights
      expect(play.working_hash).to eql({ :blk_kht_1 => [0, 1],
                                         :blk_kht_2 => [0, 6] })
    end

    it "takes key-values from hash and places them in array" do
      play = Board.new
      black = play.create_black_side
      black.create_knights
      expect(play.board).to eql([ [nil, "♞", nil, nil, nil, nil, "♞", nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil],
                                  [nil, nil, nil, nil, nil, nil, nil, nil] ])
    end
  end
end


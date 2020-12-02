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
  end
end


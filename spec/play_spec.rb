require './lib/play.rb'

describe InputOutput do
  describe "#ask_for_move" do
    it "asks the Player to enter coordinates" do
      expect(

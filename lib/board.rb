require_relative "pieces/knightsmove"

module ChessSet
  WHITE_PIECES = { :pawn => "♙", :rook => "♖", :knight => "♘",
                   :bishop => "♗", :queen => "♕", :king => "♔" }
  BLACK_PIECES = { :pawn => "♟︎", :rook => "♜", :knight => "♞",
                   :bishop => "♝", :queen => "♛", :king => "♚" }
end

class Board
  include ChessSet

  attr_accessor :board

  def initialize
    pp @board = Array.new(8, Array.new(8, 0))
  end

  def allowable_move?(position)
    if position[0] < 0 || position[1] < 0
      false
    elsif position[0] > 8 || position[1] > 8
      false
    else
      true
    end
  end  

  def create_knight
    Knight.new(self)
  end
end

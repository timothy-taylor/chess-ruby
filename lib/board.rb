require_relative "pieces/knightsmove"

module ChessSet
  WHITE_PIECES = { :pawn => "♙", :rook => "♖", :knight => "♘",
                   :bishop => "♗", :queen => "♕", :king => "♔" }
  BLACK_PIECES = { :pawn => "♟︎", :rook => "♜", :knight => "♞",
                   :bishop => "♝", :queen => "♛", :king => "♚" }
  def setup(array, w = WHITE_PIECES, b = BLACK_PIECES)
    black_back_row = [b[:rook], b[:knight], b[:bishop], b[:king], b[:queen],
                      b[:bishop], b[:knight], b[:rook]]
    black_front_row = Array.new(8, b[:pawn])
    white_back_row = [w[:rook], w[:knight], w[:bishop], w[:king], w[:queen],
                      w[:bishop], w[:knight], w[:rook]]
    white_front_row = Array.new(8, w[:pawn])

    populate_row(0, array, black_back_row)
    populate_row(1, array, black_front_row)
    populate_row(7, array, white_back_row)
    populate_row(6, array, white_front_row)
  end

  def populate_row(row, array, set)
    array[row].each_with_index { |e, i| array[row][i] = set[i] }
  end
end

class Board
  include ChessSet

  attr_accessor :board

  def initialize
    @board = Array.new(8) {Array.new(8, "-")}
    setup(@board)
    pp @board
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

require_relative "pieces/knightsmove"

module ChessSet
  WHITE_PIECES = { :pawn => "♙", :rook => "♖", :knight => "♘",
                   :bishop => "♗", :queen => "♕", :king => "♔" }
  BLACK_PIECES = { :pawn => "♟︎", :rook => "♜", :knight => "♞",
                   :bishop => "♝", :queen => "♛", :king => "♚" }
 
  def setup(array, w = WHITE_PIECES, b = BLACK_PIECES)
    black_front_row = Array.new(8, b[:pawn])
    black_back_row = [b[:rook], b[:knight], b[:bishop], b[:queen], b[:king],
                      b[:bishop], b[:knight], b[:rook]]
 
    white_front_row = Array.new(8, w[:pawn])
    white_back_row = [w[:rook], w[:knight], w[:bishop], w[:queen], w[:king],
                      w[:bishop], w[:knight], w[:rook]]

    populate_row(black_back_row, 0, array)
    populate_row(black_front_row, 1, array)
    populate_row(white_back_row, 7, array)
    populate_row(white_front_row, 6, array)
  end

  def populate_row(set, row, array)
    array[row].each_with_index { |e, i| array[row][i] = set[i] }
  end
end

class Board
  include ChessSet

  attr_accessor :board

  def initialize
    @board = Array.new(8) {Array.new(8)}
    setup(@board)
    pp @board
  end

  
  def allowable_move?(position)
    # needs work, need a way to register current place in array
    # make sure it doesn't go outside the array
    if @board[position[0]][position[1]].nil?
      true
    else
      false
    end
  end  

  def create_knight
    # lets use this to populate the array
    b_knight_one = Knight.new(self, [0,1])
    b_knight_two = Knight.new(self, [0,6])
    w_knight_one = Knight.new(self, [7,1])
    w_knight_two = Knight.new(self, [7,6])
  end
end

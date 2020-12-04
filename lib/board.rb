require "pry"
require "pp"

require_relative "chess_set.rb"

require_relative "pieces/knight.rb"
require_relative "pieces/rook.rb"
require_relative "pieces/bishop.rb"
#require_relative "pieces/queen.rb"
#require_relative "pieces/king.rb"
#require_relative "pieces/pawn.rb"

# frozen_string_literal: true 

class Board
  include ChessSet

  attr_accessor :board, :black, :white

  def initialize
    @board = make_board
    @black = create_black_side
    @white = create_white_side
  end

  def make_board
    Array.new(8) {Array.new(8)}
  end 

  def print_board(array = @board)
    format = array.map.with_index { |row, i|
      row.map.with_index { |e, j| e || format_board(i, j) }
    }
    # pp format
    return format
  end

  def format_board(row, element)
    if (row + element).even?
      "□"
    elsif (row + element).odd?
      "■"
    end
  end

    
  def place_piece(id_str, array = @board)
    # this version of this is no longer necessary
    # now that i am creating and assigning the pieces in the Side class
    # but it will be reworked for making moves I believe
    # so I am going to leave it until then
    piece = ID[id_str][0]
    position = ID[id_str][1]
    array[position[0]][position[1]] = piece
  end
  
  def create_black_side
    BlackSide.new(self)
  end

  def create_white_side
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
end

class BlackSide < Board
  include ChessSet

  def initialize(board)
    @parent = board
    create_pawn_ids("black")    
  end

  def create_pieces
    create_knight("blk_kht_1")
    create_knight("blk_kht_2")
    create_rook("blk_rok_1")
    create_rook("blk_rok_2") 
    create_bishop("blk_bsh_1")
    create_bishop("blk_bsh_2")
   # create_king("blk_kng_1")
   # create_queen("blk_que_1")
   # 8.times do |n| 
   #   id = "blk_pwn_#{n}"
   #   create_pawn(id)
   # end
  end

  def create_knight(id)
    symbol = ID[id][0]
    position = ID[id][1]
    @parent.board[position[0]][position[1]] = symbol
    Knight.new(id, @parent, symbol, position)
  end

  def create_rook(id)
    symbol = ID[id][0]
    position = ID[id][1]
    @parent.board[position[0]][position[1]] = symbol
    Rook.new(id, @parent, symbol, position)
  end

  def create_bishop(id)
    symbol = ID[id][0]
    position = ID[id][1]
    @parent.board[position[0]][position[1]] = symbol
    Bishop.new(id, @parent, symbol, position)
  end

  def create_king(id)
    symbol = ID[id][0]
    position = ID[id][1]
    @parent.board[position[0]][position[1]] = symbol
    King.new(id, @parent, symbol, position)
  end

  def create_queen(id)
    symbol = ID[id][0]
    position = ID[id][1]
    @parent.board[position[0]][position[1]] = symbol
    Queen.new(id, @parent, symbol, position)
  end

  def create_pawn(id)
    symbol = ID[id][0]
    position = ID[id][1]
    @parent.board[position[0]][position[1]] = symbol
    Pawn.new(id, @parent, symbol, position)
  end
end

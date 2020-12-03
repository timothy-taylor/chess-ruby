require "pry"
require "pp"
require_relative "pieces/knightsmove"
require_relative "chess_set.rb"

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
    fmt = array.map { |e|
      e.map { |j| j || '□' }
    }
    pp fmt
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

  attr_accessor :blk_kht_1

  def initialize(board)
    @parent = board
    create_pawn_ids("black")
    
  end

  def create_pieces
    create_knight(self, "blk_kht_1")
    create_knight(self, "blk_kht_2")
    create_rook(self, "blk_rok_1")
    create_rook(self, "blk_rok_2") 
    create_bishop(self, "blk_bsh_1")
    create_bishop(self, "blk_bsh_2")
    create_king(self, "blk_kng_1")
    create_queen(self, "blk_que_1")
    8.times do |n| 
      id = "blk_pwn_#{n}"
      create_pawn(self, id)
    end
  end

  def create_knight(parent, id)
    symbol = ID[id][0]
    position = ID[id][1]
    Knight.new(id, parent, symbol, position)
    @parent.board[position[0]][position[1]] = symbol
  end

  def create_rook(parent, id)
  end

  def create_bishop(parent, id)
  end

  def create_king(parent, id)
  end

  def create_queen(parent, id)
  end

  def create_pawn(parent, id)
  end
end

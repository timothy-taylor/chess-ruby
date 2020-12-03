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
    piece = ID[id_str][0]
    position = ID[id_str][1]
    array[position[0]][position[1]] = piece
  end
  
  def create_black_side
    BlackSide.new(self)
  end

  def create_white_side
    WhiteSide.new(self)
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
    create_knights
    create_rooks
    create_bishops
    create_king
    create_queen
    create_pawns
  end

  def create_knights
    place_piece("blk_kht_1", @parent.board)
    place_piece("blk_kht_2", @parent.board)
  end

  def create_rooks
    place_piece("blk_rok_1", @parent.board)
    place_piece("blk_rok_2", @parent.board)
  end

  def create_bishops
    place_piece("blk_bsh_1", @parent.board)
    place_piece("blk_bsh_2", @parent.board)
  end

  def create_king
    place_piece("blk_kng_1", @parent.board)
  end

  def create_queen
    place_piece("blk_que_1", @parent.board)
  end

  def create_pawns
    8.times do |n|
      id = "blk_pwn_#{n}"
      place_piece(id, @parent.board)
    end
  end
end

class WhiteSide < Board
  include ChessSet

  def initialize(board)
    @parent = board
    create_pawn_ids("white")
    create_knights
    create_rooks
    create_bishops
    create_king
    create_queen
    create_pawns
  end

  def create_knights
    place_piece("wht_kht_1", @parent.board)
    place_piece("wht_kht_2", @parent.board)
  end

  def create_rooks
    place_piece("wht_rok_1", @parent.board)
    place_piece("wht_rok_2", @parent.board)
  end

  def create_bishops
    place_piece("wht_bsh_1", @parent.board)
    place_piece("wht_bsh_2", @parent.board)
  end

  def create_king
    place_piece("wht_kng_1", @parent.board)
  end

  def create_queen
    place_piece("wht_que_1", @parent.board)
  end

  def create_pawns
    8.times do |n|
      id = "wht_pwn_#{n}"
      place_piece(id, @parent.board)
    end
  end
end

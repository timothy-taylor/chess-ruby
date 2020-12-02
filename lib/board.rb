require "pry"
require_relative "pieces/knightsmove"
require_relative "chess_set.rb"

class Board
  include ChessSet

  attr_accessor :board, :black, :white

  def initialize
  end

  def make_board
    @board = Array.new(8) {Array.new(8)}
  end 
    
  def place_piece(id_str, array = @board)
    piece = ID[id_str][0]
    position = ID[id_str][1]
    array[position[0]][position[1]] = piece
    return array
  end
  
  def create_black_side
    @black = BlackSide.new
  end

  def create_white_side
    @white = WhiteSide.new
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
  
  attr_accessor :blk_kht_1, :blk_kht_2

  def initialize
  end

  def create_knights
    binding.pry
    @blk_kht_1 = Knight.new(self, [0, 1])
    update_hash("blk_kht_1", blk_kht_1.current_pos)
    @blk_kht_2 = Knight.new(self, [0, 6])
    update_hash("blk_kht_2", blk_kht_2.current_pos)
  end
end

class WhiteSide < Board
  include ChessSet

  attr_accessor :wht_kht_1, :wht_kht_2

  def initialize
    create_knight
  end

  def create_knight
    wht_kht_1 = Knight.new(self, [7, 1])
    wht_kht_2 = Knight.new(self, [7, 6])
  end
end

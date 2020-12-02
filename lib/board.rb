require "pry"
require_relative "pieces/knightsmove"
require_relative "chess_set.rb"

class Board
  include ChessSet

  attr_accessor :board, :working_hash, :black, :white

  def initialize
    @board = Array.new(8) {Array.new(8)}
    @working_hash = Hash.new
  end

  def update_hash(key, value)
    @working_hash.store(key, value)
  end

  def create_black_side
    @black = BlackSide.new
  end

  def create_white_side
    @white = WhiteSide.new
  end

  def print_board
    pp @board
  end
  
  def allowable_move?(position)
    # needs work, need a way to register current place in array
    if position[0] < 0 || position[1] < 0 # probably move this to beginning
        false
    elsif position[0] > 8 || position[1] > 8
        false
    else
      if @board[position[0]][position[1]].nil?
        true
      # elsif board is position is occupied by other player
      else
        # define king logic
        false
      end
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

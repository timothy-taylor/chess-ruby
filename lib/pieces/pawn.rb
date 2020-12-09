require 'pry'

require_relative "../movement.rb"
require_relative "../board.rb"
require_relative "../chess_set.rb"

class Pawn
  attr_reader :symbol, :id, :move_tree
  attr_accessor :current_pos

  def initialize(id, parent, symbol, position)
    @id = id
    @gameboard = parent
    @symbol = symbol
    @current_pos = position
    @move_tree = Tree.new(position)
  end

  def available_moves(pos = @current_pos)
    first_move = true
    allowable = []
    possible_moves = []
    first_move = false unless pos == @move_tree.root.position
    possible_moves << basic_move_direction(@id, pos) 
    possible_moves << diagonal_take_left(@id, pos) 
    possible_moves << diagonal_take_right(@id, pos) 
    possible_moves << first_move_direction(@id, pos, first_move)
    possible_moves.each{ |e| 
      allowable << e if @gameboard.allowable_move?(e, self) 
    }
    return allowable
  end

  def basic_move_direction(id, position)
    x = position[0]
    y = position[1]
    id.start_with?("blk") ? [x + 1, y] : [x - 1, y]
  end

  def first_move_direction(id, position, first_move)
    return nil unless first_move
    x = position[0]
    y = position[1]
    id.start_with?("blk") ? [x + 2, y] : [x - 2, y]
  end

  def diagonal_take_left(id, position)
    x = position[0]
    y = position[1]
    id.start_with?("blk") ? [x + 1, y + 1] : [x - 1, y + 1]
  end

  def diagonal_take_right(id, position)
    x = position[0]
    y = position[1]
    id.start_with?("blk") ? [x + 1, y - 1] : [x - 1, y - 1]
  end 

  def moves(dest, start = @current_pos)
    node = @move_tree.populate_and_return(self, dest)
    #@move_tree.retrace_steps(start, node)
  end
end

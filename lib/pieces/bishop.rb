require_relative "../movement.rb"
require_relative "../board.rb"
require_relative "../chess_set.rb"

class Bishop
  attr_accessor :current_pos, :symbol, :id, :move_tree

  def initialize(id, parent, symbol, position)
    @id = id
    @gameboard = parent
    @symbol = symbol
    @current_pos = position
    @move_tree = Tree.new(position)
  end

  def available_moves(position = @current_pos)
    x = position[0]
    y = position[1]
    allowable = []
    possible_moves = []
    7.times do |n|
      possible_moves << [x + (n + 1), y + (n + 1)]
      possible_moves << [x - (n + 1), y - (n + 1)]
    end
    possible_moves.each{ |e| allowable << e if @gameboard.allowable_move?(e) }
    return allowable
  end

  def moves(dest = [1, 3], start = @current_pos)
    node = @move_tree.populate_and_return(self, dest, @move_tree.root)
    #@move_tree.retrace_steps(start, node)
  end
end

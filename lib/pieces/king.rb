require_relative "../movement.rb"
require_relative "../board.rb"
require_relative "../chess_set.rb"

class King
  attr_reader :symbol, :id, :move_tree
  attr_accessor :current_pos

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
    possible_moves = [ [x + 1, y + 0], [x + 1, y + 1],
                       [x - 1, y + 0], [x - 1, y - 1],
                       [x + 0, y + 1], [x + 0, y - 1],
                       [x + 1, y - 1], [x - 1, y + 1] ]
    possible_moves.each{ |e| allowable << e if @gameboard.allowable_move?(e) }
    return allowable
  end

  def moves(dest, start = @current_pos)
    node = @move_tree.populate_and_return(self, dest)
    #@move_tree.retrace_steps(start, node)
  end
end

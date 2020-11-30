require_relative "../movement.rb"
require_relative "../board.rb"

class Knight
  attr_accessor :current_pos

  def initialize(parent, position)
    @board = parent
    @current_pos = position
  end

  def available_moves(position)
    x = position[0]
    y = position[1]
    allowable = []
    possible_moves = [ [x + 2, y + 1], [x + 2, y - 1],
                       [x + 1, y + 2], [x + 1, y - 2],
                       [x - 2, y + 1], [x - 2, y - 1],
                       [x - 1, y + 2], [x - 1, y - 2] ]
    possible_moves.each{ |e| allowable << e if @board.allowable_move?(e) }
    return allowable
  end

  def knight_moves(finish)
    move_tree = Tree.new(@current_pos)
    node = move_tree.populate_and_return(self, finish, move_tree.root)
    move_tree.retrace_steps(@current_pos, node)
  end
end

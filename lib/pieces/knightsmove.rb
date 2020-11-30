require_relative "../movement.rb"
require_relative "../board.rb"

class Knight
  attr_reader :start_pos

  def initialize(parent)
    @board = parent
    # @start_pos = [0, 2]
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

  def knight_moves(start, finish)
    move_tree = Tree.new(start)
    node = move_tree.populate_and_return(self, finish, move_tree.root)
    move_tree.retrace_steps(start, node)
  end
end

# frozen_string_literal: true

require_relative '../movement'
require_relative '../board'
require_relative '../chess_set'

class Knight
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
    possible_moves = [[x + 2, y + 1], [x + 2, y - 1],
                      [x + 1, y + 2], [x + 1, y - 2],
                      [x - 2, y + 1], [x - 2, y - 1],
                      [x - 1, y + 2], [x - 1, y - 2]]
    possible_moves.each do |e|
      allowable << e if @gameboard.allowable_move?(e, self)
    end
    allowable
  end

  def moves(finish)
    @move_tree.populate_and_return(self, finish)
  end
end

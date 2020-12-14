# frozen_string_literal: true

require_relative '../movement'
require_relative '../board'
require_relative '../chess_set'

class Queen
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
    legal_move(x, y, allowable, 'down')
    legal_move(x, y, allowable, 'right')
    legal_move(x, y, allowable, 'up')
    legal_move(x, y, allowable, 'left')
    legal_move(x, y, allowable, 'upright')
    legal_move(x, y, allowable, 'upleft')
    legal_move(x, y, allowable, 'downright')
    legal_move(x, y, allowable, 'downleft')
    allowable
  end

  def legal_move(x, y, array, key)
    n = 0
    legal_move = true
    while legal_move do
      move = @gameboard.move_key(x, y, key, n)
      n += 1
      legal_move = @gameboard.allowable_move?(move, self)
      array << move if @gameboard.allowable_move?(move, self)
    end
  end

  def moves(dest)
    @move_tree.populate_and_return(self, dest)
  end
end

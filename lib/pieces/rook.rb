# frozen_string_literal: true

require 'pry'

require_relative '../movement'
require_relative '../board'
require_relative '../chess_set'

class Rook
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
    possible_moves = []

    n = 0
    legal_move = true
    while legal_move do
      possible_moves << [x + (n + 1), y]
      move = possible_moves[n]
      n += 1
      legal_move = @gameboard.allowable_move?(move, self)
      allowable << move if @gameboard.allowable_move?(move, self)
    end
    n = 0
    legal_move = true
    while legal_move do
      possible_moves << [x, y + (n + 1)]
      move = possible_moves[n]
      n += 1
      legal_move = @gameboard.allowable_move?(move, self)
      allowable << move if @gameboard.allowable_move?(move, self)
    end
    allowable
  end

  def moves(finish)
    @move_tree.populate_and_return(self, finish)
  end
end

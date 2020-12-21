# frozen_string_literal: true

require 'pry'

require_relative '../board'
require_relative '../chess_set'

class Pawn
  attr_reader :symbol, :id
  attr_accessor :current_pos, :previous_pos

  def initialize(id, symbol, position)
    @id = id
    @symbol = symbol
    @current_pos = position
    @previous_pos = nil
  end

  def available_moves(board)
    allowable = []
    possible_moves = []
    possible_moves << basic_move_direction(@id, @current_pos)
    possible_moves << diagonal_take_left(@id, @current_pos)
    possible_moves << diagonal_take_right(@id, @current_pos)
    possible_moves << first_move_direction(@id, @current_pos)
    possible_moves.each do |e|
      allowable << e if board.allowable_move?(e, self)
    end
    allowable
  end

  def basic_move_direction(id, position)
    x = position[0]
    y = position[1]
    id.start_with?('blk') ? [x + 1, y] : [x - 1, y]
  end

  def first_move_direction(id, position)
    return nil unless @previous_pos.nil?
    x = position[0]
    y = position[1]
    id.start_with?('blk') ? [x + 2, y] : [x - 2, y]
  end

  def diagonal_take_left(id, position)
    x = position[0]
    y = position[1]
    id.start_with?('blk') ? [x + 1, y + 1] : [x - 1, y + 1]
  end

  def diagonal_take_right(id, position)
    x = position[0]
    y = position[1]
    id.start_with?('blk') ? [x + 1, y - 1] : [x - 1, y - 1]
  end
end

# frozen_string_literal: true

require_relative '../board'
require_relative '../chess_set'

class Knight
  attr_reader :symbol, :id
  attr_accessor :current_pos, :previous_pos

  def initialize(id, symbol, position)
    @id = id
    @symbol = symbol
    @current_pos = position
    @previous_pos = nil
  end

  def available_moves(board)
    x = @current_pos[0]
    y = @current_pos[1]
    allowable = []
    possible_moves = [[x + 2, y + 1], [x + 2, y - 1],
                      [x + 1, y + 2], [x + 1, y - 2],
                      [x - 2, y + 1], [x - 2, y - 1],
                      [x - 1, y + 2], [x - 1, y - 2]]
    possible_moves.each do |e|
      allowable << e if board.allowable_move?(e, self)
    end
    allowable
  end
end

# frozen_string_literal: true

require 'pry'

class Node
  attr_accessor :position, :previous

  def initialize(position, previous)
    @position = position
    @previous = previous
  end
end

class Tree
  attr_accessor :root, :current

  def initialize(position)
    @root = Node.new(position, nil)
    @current = @root
  end

  def populate_and_return(piece, finish_pos)
    moves = piece.available_moves
    moves.each do |move|
      piece.move_tree.current = Node.new(move, piece.move_tree.current) if move == finish_pos
    end
    piece.move_tree.current
  end
end

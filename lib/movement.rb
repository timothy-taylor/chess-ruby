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
    moves.each { |move|
      if move == finish_pos
        piece.move_tree.current = Node.new(move, piece.move_tree.current)
      end
    }
    return piece.move_tree.current
  end

  def retrace_steps(start_position, node, queue = [])
    position = node.position
    steps = 0
    until node == @root
      steps += 1
      queue.unshift(node)
      node = node.previous
    end
    puts "You found #{position} after #{steps} moves. From #{start_position}:"
    queue.each { |node| p node.position }
  end
end

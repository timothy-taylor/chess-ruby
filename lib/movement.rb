class Node
  attr_accessor :position, :previous

  def initialize(position, previous)
    @position = position
    @previous = previous
  end
end

class Tree
  attr_accessor :root

  def initialize(position)
    @root = Node.new(position, nil)
  end

  def populate_and_return(piece, finish_position, root)
    queue = [root]
    until queue[0].position == finish_position
      parent_node = queue.shift
      moves = piece.available_moves(parent_node.position)
      moves.each { |move| queue.push(Node.new(move, parent_node)) }
    end
    return queue[0]
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

module PartTwo
  extend self

  def example_solution
    6
  end

  def actual_solution

  end

  def main(input)
    path = input.split("\n").first.chars

    nodes = input.split("\n").drop(2).map do |line|
      match = line.match /([A-Z0-9]+) = \(([A-Z0-9]+), ([A-Z0-9]+)\)/

      [match[1], Node.new(match[1], match[2], match[3])]
    end.to_h

    starting_nodes = nodes.values.select { |node| node.id[2] == 'A' }
    ghost = Ghost.new(starting_nodes, nodes)

    i = 0
    loop do
      direction = path[i % path.size]

      ghost.step direction
      i += 1

      break if ghost.at_finish?
    end

    i
  end

  private

  Node = Struct.new(:id, :left, :right)

  class Ghost
    def initialize(current_nodes, nodes)
      @current_nodes = current_nodes
      @nodes = nodes
    end

    def step(direction)
      @current_nodes = @current_nodes.map do |current_node|
        case direction
        when 'L' then @nodes[current_node.left]
        when 'R' then @nodes[current_node.right]
        end
      end
    end

    def at_finish?
      @current_nodes.all? { _1.id[2] == 'Z' }
    end
  end
end

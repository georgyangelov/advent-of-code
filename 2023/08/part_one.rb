module PartOne
  extend self

  def example_solution
    6
  end

  def actual_solution
    21797
  end

  def main(input)
    path = input.split("\n").first.chars

    nodes = input.split("\n").drop(2).map do |line|
      match = line.match /([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)/

      [match[1], Node.new(match[2], match[3])]
    end.to_h

    i = 0
    current_node = nodes['AAA']
    loop do
      next_node_id =
        case path[i % path.size]
        when 'L' then current_node.left
        when 'R' then current_node.right
        end

      i += 1

      break if next_node_id == 'ZZZ'

      current_node = nodes[next_node_id]
    end

    i
  end

  private

  Node = Struct.new(:left, :right)
end

require 'set'

module PartTwo
  extend self

  def example_solution
    6
  end

  def actual_solution
    23977527174353
  end

  def main(input)
    path = input.split("\n").first.chars

    nodes = input.split("\n").drop(2).map do |line|
      match = line.match /([A-Z0-9]+) = \(([A-Z0-9]+), ([A-Z0-9]+)\)/

      [match[1], Node.new(match[1], match[2], match[3])]
    end.to_h

    starting_nodes = nodes.values.select { |node| node.id[2] == 'A' }

    # ghost = Ghost.new(starting_nodes, nodes)

    path_sizes = starting_nodes.map do |starting_node|
      Walker.new(starting_node, nodes).walk(path)
    end

    path_sizes.reduce(1, :lcm)
  end

  private

  Node = Struct.new(:id, :left, :right)

  class Walker
    def initialize(current_node, nodes)
      @current_node = current_node
      @nodes = nodes
    end

    def walk(path)
      i = 0
      # endings = []
      # node_path = [@current_node.id]
      # visited_end_node_ids = Set.new

      # times = 10

      loop do
        direction = path[i % path.size]

        @current_node =
          case direction
          when 'L' then @nodes[@current_node.left]
          when 'R' then @nodes[@current_node.right]
          end

        i += 1

        # node_path << @current_node.id

        if @current_node.id[2] == 'Z'
          break

          # break if visited_end_node_ids.include? @current_node.id
          # if visited_end_node_ids.include? @current_node.id
          #   times -= 1
          #   break if times == 0
          # end
          #
          # visited_end_node_ids.add(@current_node.id)
          #
          # endings << [@current_node.id, i]
        end
      end

      i
    end
  end
end

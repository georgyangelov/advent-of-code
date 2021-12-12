module PartTwo
  extend self

  def example_solution
    36
  end

  def actual_solution
  end

  def main(input)
    parsed_input = input.split("\n").map { |line| line.split('-') }

    solve parsed_input
  end

  def solve(tunnels)
    map = CaveMap.new tunnels

    map.routes('start', 'end').size
  end

  class CaveMap
    def initialize(tunnels)
      @caves = {}

      tunnels.each do |from, to|
        @caves[from] ||= []
        @caves[from] << to

        @caves[to] ||= []
        @caves[to] << from
      end
    end

    def caves
      @caves.keys
    end

    def neighbours_of(node)
      @caves[node]
    end

    def big_cave?(node)
      node =~ /^[A-Z]+$/
    end

    def small_cave?(node)
      node =~ /^[a-z]+$/
    end

    def routes(from, to, visited_small_caves = [], visited_small_cave_twice = false)
      return [to] if from == to

      visited_small_cave_twice = true if visited_small_caves.include? from
      visited_small_caves += [from] if small_cave? from

      neighbours = neighbours_of(from)
      neighbours -= visited_small_caves if visited_small_cave_twice
      neighbours -= ['start']

      neighbours.flat_map do |neighbour|
        routes(neighbour, to, visited_small_caves, visited_small_cave_twice)
          .map { |route| [from, *route] }
      end
    end
  end

  private


end

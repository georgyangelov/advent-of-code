module PartOne
  extend self

  def example_solution
    10
  end

  def actual_solution
    3576
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

    def routes(from, to, visited = [])
      return [to] if from == to

      neighbours = neighbours_of(from) - visited

      neighbours.flat_map do |neighbour|
        new_visited =
          if small_cave? from
            visited + [from]
          else
            visited
          end

        routes(neighbour, to, new_visited).map { |route| [from, *route] }
      end
    end
  end

  private


end

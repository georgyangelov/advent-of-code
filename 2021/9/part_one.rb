module PartOne
  extend self

  def example_solution
    15
  end

  def actual_solution
    475
  end

  def main(input)
    parsed_input = input.split("\n").map do |line|
      line.chars.map(&:to_i)
    end

    solve parsed_input
  end

  def solve(heightmap)
    scan_adjacent heightmap do |height, adjacent|
      height + 1 if adjacent.all? { |h| h > height }
    end.sum
  end

  private

  def scan_adjacent(heightmap)
    xmax = heightmap.first.size - 1
    ymax = heightmap.size - 1

    (0...heightmap.size).flat_map do |y|
      (0...heightmap[y].size).map do |x|
        yield heightmap[y][x], [
          x - 1 >= 0 ? heightmap[y][x - 1] : nil,
          y - 1 >= 0 ? heightmap[y - 1][x] : nil,
          x + 1 <= xmax ? heightmap[y][x + 1] : nil,
          y + 1 <= ymax ? heightmap[y + 1][x] : nil,
        ].compact
      end.compact
    end
  end
end

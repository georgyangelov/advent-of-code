module PartTwo
  extend self

  def example_solution
    1134
  end

  def actual_solution
    1092012
  end

  def main(input)
    parsed_input = input.split("\n").map do |line|
      line.chars.map(&:to_i)
    end

    solve parsed_input
  end

  def solve(heightmap)
    basin_sizes = identify_basins heightmap

    basin_sizes.sort.reverse.take(3).reduce(:*)
  end

  private

  def identify_basins(heightmap)
    heightmap = heightmap.clone

    heightmap.each_index.flat_map do |y|
      heightmap[y].each_index.map do |x|
        next if heightmap[y][x] == 9

        size = basin_size!(heightmap, y, x)
      end.compact
    end
  end

  def basin_size!(heightmap, y, x)
    return 0 if heightmap[y][x] == 9

    heightmap[y][x] = 9

    size = 1
    size += basin_size!(heightmap, y, x - 1) if x > 0
    size += basin_size!(heightmap, y, x + 1) if x < heightmap[y].size - 1
    size += basin_size!(heightmap, y - 1, x) if y > 0
    size += basin_size!(heightmap, y + 1, x) if y < heightmap.size - 1
    size
  end
end

module PartTwo
  extend self

  def example_solution
    12
  end

  def actual_solution
    19771
  end

  def main(input)
    lines = input.split("\n").map do |line|
      line.split('->').map { |vector| vector.split(',').map(&:to_i) }
    end

    solve lines
  end

  def solve(lines)
    lines
      .flat_map { |line| interpolate_line_points(line) }
      .tally
      .count { |_, count| count > 1 }
  end

  def interpolate_line_points(line)
    (from_x, from_y), (to_x, to_y) = line.sort

    if from_x == to_x
      (from_y..to_y).map { |y| [from_x, y] }
    elsif from_y == to_y
      (from_x..to_x).map { |x| [x, from_y] }
    else
      y_direction = to_y <=> from_y

      (from_x..to_x).map.with_index { |_, i| [from_x + i, from_y + i*y_direction] }
    end
  end
end

module PartOne
  extend self

  def example_solution
    5
  end

  def actual_solution
    5124
  end

  def main(input)
    lines = input.split("\n").map do |line|
      line.split('->').map { |vector| vector.split(',').map(&:to_i) }
    end.to_a

    solve lines
  end

  def solve(lines)
    lines
      .select { |(x1, y1), (x2, y2)| x1 == x2 || y1 == y2 }
      .flat_map { |line| interpolate_line_points(line) }
      .tally
      .count { |_, count| count > 1 }
  end

  def interpolate_line_points(line)
    (from_x, from_y), (to_x, to_y) = line.sort

    if from_x == to_x
      (from_y..to_y).map { |y| [from_x, y] }
    else
      (from_x..to_x).map { |x| [x, from_y] }
    end
  end
end

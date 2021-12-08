module PartTwo
  extend self

  def example_solution
    168
  end

  def actual_solution
    91638945
  end

  def main(input)
    parsed_input = input.split(',').map(&:to_i)

    solve parsed_input
  end

  def solve(crab_positions)
    target_range = crab_positions.min..crab_positions.max
    optimal_target = target_range.min_by { |target| distance_to(crab_positions, target) }

    distance_to(crab_positions, optimal_target)
  end

  private

  def distance_to(crab_positions, n)
    crab_positions.map { |x| (1..(x - n).abs).sum }.sum
  end
end

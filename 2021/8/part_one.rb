module PartOne
  extend self

  def example_solution
    26
  end

  def actual_solution
    321
  end

  def main(input)
    parsed_input = input.split("\n").map do |line|
      patterns, outputs = line.split(' | ')

      [patterns.split(' '), outputs.split(' ')]
    end

    solve parsed_input
  end

  def solve(displays)
    displays.map do |patterns, outputs|
      outputs.count { |output| [2, 4, 3, 7].include? output.size }
    end.sum
  end

  private

end

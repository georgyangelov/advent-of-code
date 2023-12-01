module PartOne
  extend self

  def example_solution
    142
  end

  def actual_solution
    53651
  end

  def main(input)
    input.split("\n")
      .map do |line|
        chars = line.chars.select { _1 =~ /[0-9]/ }

        (chars.first + chars.last).to_i
      end
      .sum
  end
end

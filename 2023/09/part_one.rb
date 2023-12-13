module PartOne
  extend self

  def example_solution
    114
  end

  def actual_solution
    1938800261
  end

  def main(input)
    sequences = input.split("\n").map { _1.split(' ').map { |n| n.to_i } }

    sequences.map { |sequence| extrapolate(sequence) }.sum
  end

  private

  def extrapolate(sequence)
    return 0 if sequence.all? { _1 == 0 }

    derivatives = sequence.each_cons(2).map { _2 - _1 }
    next_derivative = extrapolate(derivatives)

    sequence.last + next_derivative
  end
end

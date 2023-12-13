module PartOne
  extend self

  def example_solution
    21
  end

  def actual_solution
    7025
  end

  def main(input)
    records = input.split("\n").map do |line|
      springs, groups = line.split(' ')

      Record.new(
        springs,
        groups.split(',').map(&:to_i)
      )
    end

    records.map { solve_record(_1) }.sum
  end

  private

  Record = Struct.new(:springs, :groups)

  def solve_record(record)
    possible_matches ".#{record.springs}.", record.groups
  end

  def possible_matches(springs, numbers)
    spaces = springs.size - numbers.sum

    distributions = possible_distributions(spaces, numbers.size + 1)
    distributions.select { possible?(build_spring(numbers, _1), springs) }.size
  end

  def possible_distributions(spaces, slots, parent = [])
    return [[*parent, spaces]] if slots == 1

    # p "spaces = #{spaces.inspect}, slots = #{slots.inspect}, parent = #{parent.inspect}"

    possibilities = []

    (1..spaces).each do |i|
      break if spaces - i < slots - 1

      current = [*parent, i]
      inner_possible = possible_distributions(spaces - i, slots - 1, current)

      # p "spaces = #{spaces - i}, slots = #{slots - 1}, current = #{current.inspect}"
      # p inner_possible

      possibilities.concat(inner_possible)

      # break if inner_possible.size == 0
    end

    possibilities
  end

  def build_spring(numbers, spaces)
    result = '.' * spaces[0]

    numbers.zip(spaces.drop(1)).each do |num, spaces|
      result += '#' * num
      result += '.' * spaces
    end

    result
  end

  def possible?(springs, springs_with_holes)
    # p springs, springs_with_holes
    # Optimize
    springs.chars.zip(springs_with_holes.chars).all? do |a, b|
      a == b || b == '?'
    end
  end
end

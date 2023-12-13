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
    possible_matches record.springs, record.groups
  end

  def possible_matches(springs, numbers, hash = {})
    original_springs = springs

    if numbers.size == 0
      if springs.include? '#'
        return 0
      else
        return 1
      end
    end

    memo = hash[[springs, numbers]]
    return memo if memo

    matches = 0

    has_match = match_at_start?(springs, numbers[0])
    if has_match
      rest_of_springs = springs[(numbers[0] + 1)..] || ''

      possible_rest_variations = possible_matches(rest_of_springs, numbers.drop(1), hash)

      matches += possible_rest_variations
    end

    if springs[0] != '#' && springs.size > 1
      matches += possible_matches(springs[1..], numbers, hash)
    end

    hash[[original_springs, numbers]] = matches

    matches
  end

  def match_at_start?(springs, number)
    i = 0

    return false if springs.size < number

    while i < number
      return false if springs[i] == '.'

      i += 1
    end

    !springs[i] || springs[i] != '#'
  end
end

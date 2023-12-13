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

  def possible_matches(springs, numbers, level = 1, hash = {})
    original_springs = springs

    if numbers.size == 0
      if springs =~ /^[\.?]*$/
        return 1
      else
        return 0
      end
    end

    first_number = numbers[0]
    matches = 0

    memo = hash[[springs, numbers]]
    if memo
      # puts "'#{original_springs}' #{numbers.join(',')} -> #{matches}"
      return memo
    end

    loop do
      break if springs.size < first_number

      has_match = match_at_start?(springs, first_number)
      if has_match
        rest_of_springs = springs[(first_number + 1)..] || ''

        possible_rest_variations = possible_matches(rest_of_springs, numbers.drop(1), level + 1, hash)

        # puts "'#{springs}' #{numbers.join(',')} -> "

        matches += possible_rest_variations
      end

      break if springs[0] == '#' || springs.size == 1

      springs = springs[1..]
    end

    hash[[original_springs, numbers]] = matches

    # puts "'#{original_springs}' #{numbers.join(',')} -> #{matches}" if level <= 5

    matches
  end

  def match_at_start?(springs, number)
    i = 0

    while i < number
      return false if springs[i] == '.'

      i += 1
    end

    !springs[i] || springs[i] != '#'
  end
end

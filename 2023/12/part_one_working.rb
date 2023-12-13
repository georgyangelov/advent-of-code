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

  def possible_matches(springs, numbers, level = 1)
    original_springs = springs

    if numbers.size == 0
      if springs =~ /^[\.?]*$/
        return 1
      else
        return 0
      end
    elsif springs.size == 0
      return 0
    end

    first_number = numbers[0]
    matches = 0

    loop do
      offset = first_number_offset(springs, first_number)
      break unless offset

      rest_of_springs = springs[(offset + first_number + 1)..] || ''

      possible_rest_variations = possible_matches(rest_of_springs, numbers.drop(1), level + 1)

      matches += possible_rest_variations

      offset_to_remove_until = offset + 1
      index_of_first_fixed = springs.index('#')

      break if offset_to_remove_until >= springs.size
      break if index_of_first_fixed && index_of_first_fixed <= offset

      springs = springs[offset_to_remove_until..]
    end

    # puts "'#{original_springs}' #{numbers.join(',')} -> #{matches}"

    matches
  end

  def first_number_offset(springs, number)
    match = springs.match(/^[.?]*?([#?]{#{number}})($|\.|\?)/)

    return unless match

    # puts "'#{springs}' matches #{number} -> #{match[1]}"

    match.begin(1)
  end
end

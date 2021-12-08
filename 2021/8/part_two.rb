module PartTwo
  extend self

  DIGIT_MAP = {
    'abcefg'  => 0,
    'cf'      => 1,
    'acdeg'   => 2,
    'acdfg'   => 3,
    'bcdf'    => 4,
    'abdfg'   => 5,
    'abdefg'  => 6,
    'acf'     => 7,
    'abcdefg' => 8,
    'abcdfg'  => 9,
  }.freeze

  def example_solution
    61229
  end

  def actual_solution
    1028926
  end

  def main(input)
    parsed_input = input.split("\n").map do |line|
      patterns, outputs = line.split(' | ')

      [patterns.split(' '), outputs.split(' ')]
    end

    solve parsed_input
  end

  def solve(displays)
    permutations = ('a'..'g').to_a.permutation.map(&:join)

    displays.map do |patterns, outputs|
      permutation = permutations.find do |permutation|
        patterns.all? { |pattern| DIGIT_MAP.keys.include? unscramble(permutation, pattern) }
      end

      outputs
        .map { |word| DIGIT_MAP[unscramble(permutation, word)] }
        .join('')
        .to_i
    end.sum
  end

  private

  def unscramble(permutation, word)
    word.chars.map { |char| (permutation.index(char) + 'a'.ord).chr }.sort.join('')
  end
end

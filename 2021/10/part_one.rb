module PartOne
  extend self

  CHAR_MAP = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }.freeze
  INVERSE_MAP = CHAR_MAP.invert.freeze

  SYNTAX_ERROR_POINTS = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
  }.freeze

  def example_solution
    26397
  end

  def actual_solution
    344193
  end

  def main(input)
    parsed_input = input.split("\n")

    solve parsed_input
  end

  def solve(lines)
    lines
      .map { |line| corrupted_char line }
      .compact
      .map { |char| SYNTAX_ERROR_POINTS[char] }
      .sum
  end

  private

  def corrupted_char(line)
    active_chunks = []

    line.chars.each do |char|
      if CHAR_MAP.key?(char)
        active_chunks.push char
      else
        opening_char = active_chunks.pop

        return char unless opening_char == INVERSE_MAP[char]
      end
    end

    nil
  end
end

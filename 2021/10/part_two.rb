module PartTwo
  extend self

  CHAR_MAP = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }.freeze
  INVERSE_MAP = CHAR_MAP.invert.freeze

  COMPLETION_POINTS = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
  }.freeze

  def example_solution
    288957
  end

  def actual_solution
    3241238967
  end

  def main(input)
    parsed_input = input.split("\n")

    solve parsed_input
  end

  def solve(lines)
    completion_scores = lines
      .map { line_completion_score(_1) }
      .compact
      .sort

    completion_scores[completion_scores.size / 2]
  end

  private

  def line_completion_score(line)
    active_chunks = []

    line.chars.each do |char|
      if CHAR_MAP.key?(char)
        active_chunks.push char
      else
        opening_char = active_chunks.pop

        return unless opening_char == INVERSE_MAP[char]
      end
    end

    return if active_chunks.empty?

    active_chunks
      .reverse
      .map { CHAR_MAP[_1] }
      .map { COMPLETION_POINTS[_1] }
      .reduce(0) { |total, char_score| total * 5 + char_score }
  end
end

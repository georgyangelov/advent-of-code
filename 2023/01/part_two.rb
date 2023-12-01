module PartTwo
  extend self

  WORD_DIGITS = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
  WORD_DIGITS_REGEX = /#{WORD_DIGITS.join('|')}/

  def example_solution
    281
  end

  def actual_solution
    53894
  end

  def main(input)
    input
      .lines
      .map do |line|
        first_word_index = line.index(WORD_DIGITS_REGEX) || line.size
        last_word_index = line.rindex(WORD_DIGITS_REGEX) || -1

        first_digit_index = line.index(/[0-9]/) || line.size
        last_digit_index = line.rindex(/[0-9]/) || -1

        first_digit =
          if first_word_index < first_digit_index
            extract_word_digit(line, first_word_index)
          else
            line[first_digit_index]
          end

        last_digit =
          if last_word_index > last_digit_index
            extract_word_digit(line, last_word_index)
          else
            line[last_digit_index]
          end

        "#{first_digit}#{last_digit}".to_i
      end
      .sum
  end

  private

  def extract_word_digit(string, offset)
    word = string[offset..].match(WORD_DIGITS_REGEX)[0]

    WORD_DIGITS.index(word) + 1
  end
end

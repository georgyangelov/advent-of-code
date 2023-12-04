require 'set'

module PartOne
  extend self

  def example_solution
    13
  end

  def actual_solution
    25174
  end

  def main(input)
    cards = input.split("\n").map do |line|
      winning, picked = line.sub(/Card\s+\d+:/, '').split('|')

      {
        winning: winning.scan(/\d+/).map(&:to_i),
        picked: picked.scan(/\d+/).map(&:to_i)
      }
    end

    cards.map { card_value(_1) }.sum
  end

  private

  def card_value(card)
    match_count = (card[:winning] & card[:picked]).size

    return 0 if match_count == 0

    2 ** (match_count - 1)
  end
end

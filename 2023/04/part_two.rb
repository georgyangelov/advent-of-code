require 'set'

module PartTwo
  extend self

  def example_solution
    30
  end

  def actual_solution

  end

  def main(input)
    cards = input.split("\n").map do |line|
      winning, picked = line.sub(/Card\s+\d+:/, '').split('|')

      {
        winning: winning.scan(/\d+/).map(&:to_i),
        picked: picked.scan(/\d+/).map(&:to_i),
        copies: 1
      }
    end

    cards.each.with_index do |card, index|
      wins = (card[:winning] & card[:picked]).size

      wins.times do |i|
        next if index + i + 1 >= cards.size

        cards[index + i + 1][:copies] += card[:copies]
      end
    end

    cards.map { _1[:copies] }.sum
  end

  private

end

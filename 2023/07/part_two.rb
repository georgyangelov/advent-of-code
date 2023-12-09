require 'set'

module PartTwo
  extend self

  CARDS = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']

  def example_solution
    5905
  end

  def actual_solution

  end

  def main(input)
    hands = input.split("\n").map do |line|
      cards, bid = line.split(' ')

      Hand.new(cards, bid.to_i)
    end

    hands
      .sort_by { [value_of_type(_1.cards), value_of_cards(_1.cards)] }
      .reverse
      .map.with_index { |hand, index| hand.bid * (index + 1) }
      .sum
  end

  private

  Hand = Struct.new(:cards, :bid)

  def value_of_type(cards)
    card_counts = cards.chars.reject { _1 == 'J' }.tally
    jokers = cards.chars.count { _1 == 'J' }

    five_of_a_kind  = card_counts.values.include? 5
    four_of_a_kind  = card_counts.values.include? 4
    three_of_a_kind = card_counts.values.include? 3
    two_of_a_kind   = card_counts.values.count { _1 == 2 }

    rank = [
      five_of_a_kind ||
        four_of_a_kind && jokers == 1 ||
        three_of_a_kind && jokers == 2 ||
        two_of_a_kind == 1 && jokers == 3 ||
        jokers == 4 ||
        jokers == 5,

      four_of_a_kind ||
        three_of_a_kind && jokers == 1 ||
        two_of_a_kind == 1 && jokers == 2 ||
        jokers == 3,

      three_of_a_kind && two_of_a_kind == 1 ||
        two_of_a_kind == 2 && jokers == 1,

      three_of_a_kind ||
        two_of_a_kind == 1 && jokers == 1 ||
        jokers == 2,

      two_of_a_kind == 2,

      two_of_a_kind == 1 ||
        jokers == 1,

      true
    ].find_index(true)

    puts "#{cards} -> #{['five of a kind', 'four of a kind', 'full house', 'three of a kind', 'two pairs', 'two of a kind', 'high card'][rank]}"

    rank
  end

  def value_of_cards(cards)
    cards.chars.map { CARDS.index(_1) }
  end
end

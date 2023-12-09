module PartOne
  extend self

  CARDS = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']

  def example_solution
    6440
  end

  def actual_solution
    248217452
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
    card_counts = cards.chars.tally

    five_of_a_kind  = card_counts.values.include? 5
    four_of_a_kind  = card_counts.values.include? 4
    three_of_a_kind = card_counts.values.include? 3
    two_of_a_kind   = card_counts.values.count { _1 == 2 }

    [
      five_of_a_kind,
      four_of_a_kind,
      three_of_a_kind && two_of_a_kind == 1,
      three_of_a_kind,
      two_of_a_kind == 2,
      two_of_a_kind == 1,
      true
    ].find_index(true)
  end

  def value_of_cards(cards)
    cards.chars.map { CARDS.index(_1) }
  end
end

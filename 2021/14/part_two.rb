module PartTwo
  extend self

  def example_solution
    2188189693529
  end

  def actual_solution
    3015383850689
  end

  def main(input)
    template, rules = input.split("\n\n")

    rules = rules.split("\n").map { |rule| rule.split(' -> ') }.to_h

    solve template, rules
  end

  def solve(polymer, rules)
    pair_counts = polymer.each_char.each_cons(2).map(&:join).tally
    char_counts = polymer.chars.tally

    40.times do
      pair_counts.clone.each do |pair, count|
        next unless count > 0

        insert_char = rules[pair]

        next unless insert_char

        pair_counts[pair] -= count

        a, b = pair.chars

        pair_counts["#{a}#{insert_char}"] ||= 0
        pair_counts["#{a}#{insert_char}"] += count

        pair_counts["#{insert_char}#{b}"] ||= 0
        pair_counts["#{insert_char}#{b}"] += count

        char_counts[insert_char] ||= 0
        char_counts[insert_char] += count
      end
    end

    max = char_counts.max_by { |_, count| count }.last
    min = char_counts.min_by { |_, count| count }.last

    max - min
  end

  private

end

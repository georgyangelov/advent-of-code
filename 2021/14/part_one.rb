module PartOne
  extend self

  def example_solution
    1588
  end

  def actual_solution
    2975
  end

  def main(input)
    template, rules = input.split("\n\n")

    rules = rules.split("\n").map { |rule| rule.split(' -> ') }.to_h

    solve template, rules
  end

  def solve(polymer, rules)
    10.times do
      partial = polymer.each_char.each_cons(2).map { |a, b| "#{a}#{rules["#{a}#{b}"] || ''}" }
      polymer = "#{partial.join('')}#{polymer.chars.last}"
    end

    char_counts = polymer.chars.tally
    max = char_counts.max_by { |_, count| count }.last
    min = char_counts.min_by { |_, count| count }.last

    max - min
  end

  private

end

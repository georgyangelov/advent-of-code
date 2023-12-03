module PartOne
  extend self

  def example_solution
    8
  end

  def actual_solution
    2771
  end

  def main(input)
    games = input.lines.map do |line|
      picks = line.split(';').map do |pick|
        {
          r: pick[/(\d+) red/, 1].to_i || 0,
          g: pick[/(\d+) green/, 1].to_i || 0,
          b: pick[/(\d+) blue/, 1].to_i || 0
        }
      end

      {
        id: line[/Game (\d+):/, 1].to_i,
        picks: picks
      }
    end

    games
      .select { |game| game[:picks].all? { valid_pick?(_1) } }
      .map { |game| game[:id] }
      .sum
  end

  private

  def valid_pick?(pick)
    pick[:r] <= 12 and pick[:g] <= 13 and pick[:b] <= 14
  end
end

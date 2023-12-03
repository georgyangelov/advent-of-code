module PartTwo
  extend self

  def example_solution
    2286
  end

  def actual_solution
    70924
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
      .map { min_colors(_1) }
      .map { power(_1) }
      .sum
  end

  private

  def min_colors(game)
    {
      r: game[:picks].map { _1[:r] }.max || 0,
      g: game[:picks].map { _1[:g] }.max || 0,
      b: game[:picks].map { _1[:b] }.max || 0,
    }
  end

  def power(min_colors)
    min_colors[:r] * min_colors[:g] * min_colors[:b]
  end
end

module PartOne
  extend self

  def example_solution
    5934
  end

  def actual_solution
    353079
  end

  def main(input)
    parsed_input = input.split(",").map(&:to_i)

    solve parsed_input
  end

  def solve(fish)
    80.times { fish = process_day(fish) }

    fish.size
  end

  private

  def process_day(fish)
    fish = fish.flat_map do |f|
      if f == 0
        [6, 8]
      else
        [f - 1]
      end
    end
  end
end

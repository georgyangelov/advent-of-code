module PartTwo
  extend self

  def example_solution
    26984457539
  end

  def actual_solution
    1605400130036
  end

  def main(input)
    parsed_input = input.split(',').map(&:to_i)

    solve parsed_input
  end

  def solve(fish)
    fish = 9.times.map { |i| fish.count { |f| f == i } }
    256.times { fish = process_day(fish) }

    fish.sum
  end

  private

  def process_day(fish)
    first = fish.shift

    fish.push(first)
    fish[6] += first

    fish
  end
end

module PartOne
  extend self

  def example_solution
    1320
  end

  def actual_solution
    505459
  end

  def main(input)
    steps = input.split(',')
    steps.map { hash _1 }.sum
  end

  private

  def hash(string)
    result = 0

    string.chars.each do |c|
      result = ((result + c.ord) * 17) % 256
    end

    result
  end
end

module PartTwo
  extend self

  def example_solution
    145
  end

  def actual_solution
    228508
  end

  def main(input)
    steps = input.split(',')

    machine = Machine.new
    steps.each do |step|
      if step.end_with? '-'
        machine.remove_lens(step.sub('-', ''))
      else
        label, focal_length = step.split('=')

        machine.add_lens(Lens.new(label, focal_length.to_i))
      end
    end

    machine.focusing_power
  end

  private

  Lens = Struct.new(:label, :focal_length)

  class Box
    def initialize(index)
      @index = index
      @lenses = []
    end

    def remove_lens(label)
      @lenses.delete_if { _1.label == label }
    end

    def add_lens(lens)
      index = @lenses.find_index { _1.label == lens.label }

      if index
        @lenses[index] = lens
      else
        @lenses.push lens
      end
    end

    def focusing_power
      result = 0

      @lenses.each.with_index do |lens, i|
        result += (@index + 1) * (i + 1) * lens.focal_length
      end

      result
    end
  end

  class Machine
    def initialize
      @boxes = 256.times.map { Box.new(_1) }
    end

    def remove_lens(label)
      @boxes[hash(label)].remove_lens(label)
    end

    def add_lens(lens)
      @boxes[hash(lens.label)].add_lens(lens)
    end

    def focusing_power
      @boxes.map(&:focusing_power).sum
    end

    def hash(string)
      result = 0

      string.chars.each do |c|
        result = ((result + c.ord) * 17) % 256
      end

      result
    end
  end
end

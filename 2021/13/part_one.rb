module PartOne
  extend self

  def example_solution
    17
  end

  def actual_solution
    781
  end

  def main(input)
    dot_lines, fold_instructions = input.split("\n\n")

    dots = dot_lines.split("\n").map { |line| line.split(',').map(&:to_i) }
    fold_instructions = fold_instructions.split("\n").map do |line|
      line =~ /fold along ([xy])=([0-9]+)/

      [$1, $2.to_i]
    end

    solve dots, fold_instructions
  end

  def solve(dots, fold_instructions)
    fold_along(dots, fold_instructions[0])
    # fold_instructions
    #   .reduce(dots) { |dots, fold_instruction| fold_along(dots, fold_instruction) }
      .uniq
      .size
  end

  private

  def fold_along(dots, fold_instruction)
    fold_along, fold_value = fold_instruction

    dots.map do |dot|
      case fold_along
      when 'x' then [dot[0] > fold_value ? (2*fold_value - dot[0]) : dot[0], dot[1]]
      when 'y' then [dot[0], dot[1] > fold_value ? (2*fold_value - dot[1]) : dot[1]]
      end
    end
  end
end

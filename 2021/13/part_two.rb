module PartTwo
  extend self

  def example_solution
    <<~EXAMPLE.strip
      #####
      #...#
      #...#
      #...#
      #####
    EXAMPLE
  end

  def actual_solution
    <<~SOLUTION.strip
      ###..####.###...##...##....##.###..###.
      #..#.#....#..#.#..#.#..#....#.#..#.#..#
      #..#.###..#..#.#....#.......#.#..#.###.
      ###..#....###..#....#.##....#.###..#..#
      #....#....#.#..#..#.#..#.#..#.#....#..#
      #....####.#..#..##...###..##..#....###.
    SOLUTION
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
    dots = fold_instructions
      .reduce(dots) { |dots, fold_instruction| fold_along(dots, fold_instruction) }

    draw(dots).map(&:join).join("\n")
  end

  private

  def draw(dots)
    xmax = dots.map(&:first).max
    ymax = dots.map(&:last).max

    matrix = Array.new(ymax + 1) { Array.new(xmax + 1, '.') }

    dots.each do |dot|
      matrix[dot[1]][dot[0]] = '#'
    end

    matrix
  end

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

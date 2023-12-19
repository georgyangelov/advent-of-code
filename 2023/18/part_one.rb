require_relative '../lib/map'

module PartOne
  extend self

  def example_solution
    62
  end

  def actual_solution
    68115
  end

  def main(input)
    instructions = input.split("\n").map do |line|
      direction, count, color = line.split(' ')

      Instruction.new(
        direction_from_string(direction),
        count.to_i,
        color[1..-2]
      )
    end

    rows, cols, start = determine_map_size instructions

    map = Map.empty(rows, cols) { '.' }
    fill_map map, start, instructions

    map2 = Map.new([
      ['.'] * (cols + 2),
      *map.grid.map do |row|
        ['.', *row, '.']
      end,
      ['.'] * (cols + 2),
    ])

    map2.flood_fill(Position.new(0, 0)) { map2[_1] == '.' ? 'O' : nil }

    # map2.print

    map2.each.count { |_, c| c != 'O' }
  end

  private

  Instruction = Struct.new(:direction, :count, :color)

  def direction_from_string(string)
    case string
    when 'U' then :up
    when 'R' then :right
    when 'D' then :down
    when 'L' then :left
    end
  end

  def determine_map_size(instructions)
    min_row = 0
    max_row = 0
    min_col = 0
    max_col = 0
    current = Position.new(0, 0)

    instructions.each do |i|
      current = current.move(i.direction, i.count)

      min_row = current.row if current.row < min_row
      max_row = current.row if current.row > max_row
      min_col = current.col if current.col < min_col
      max_col = current.col if current.col > max_col
    end

    start = Position.new(-min_row, -min_col)

    [max_row - min_row + 1, max_col - min_col + 1, start]
  end

  def fill_map(map, start, instructions)
    current = start

    instructions.each do |i|
      i.count.times do
        current = current.move(i.direction, 1)

        map[current] = '#'
      end
    end
  end
end

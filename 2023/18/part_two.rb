require 'set'

module PartTwo
  extend self

  def example_solution
    952408144115
  end

  def actual_solution
    71262565063800
  end

  def main(input)
    instructions = input.split("\n").map do |line|
      hex = line.split(' ').last[2..-2]

      direction =
        case hex[-1]
        when '0' then :right
        when '1' then :down
        when '2' then :left
        when '3' then :up
        end

      Instruction.new(
        direction,
        hex[..-2].to_i(16)
      )
    end

    points = build_points(Position.new(1, 1), instructions)

    min_row = points.map { _1.row }.min - 1
    min_col = points.map { _1.col }.min - 1

    points = points.map { |p| Position.new(p.row - min_row, p.col - min_col) }
    start_point = Position.new(1 - min_row, 1 - min_col)

    row_lengths = [1] + determine_lengths(points.map { _1.row }) + [1]
    col_lengths = [1] + determine_lengths(points.map { _1.col }) + [1]

    map = Map.empty(row_lengths.size, col_lengths.size) { '.' }

    update_map_with_walls(map, row_lengths, col_lengths, points)
    map.flood_fill(Position.new(0, 0)) { map[_1] == '.' ? 'O' : nil }

    map.each.sum do |pos, _|
      next 0 if map[pos] == 'O'

      row_lengths[pos.row] * col_lengths[pos.col]
    end
  end

  private

  Instruction = Struct.new(:direction, :count)

  def update_map_with_walls(map, row_lengths, col_lengths, points)
    points.each_cons(2) do |a, b|
      a_row = offset_to_index(row_lengths, a.row)
      a_col = offset_to_index(col_lengths, a.col)

      b_row = offset_to_index(row_lengths, b.row)
      b_col = offset_to_index(col_lengths, b.col)

      if a_row == b_row
        # Horizontal
        row = a_row
        col_range = [a_col, b_col].min..[a_col, b_col].max

        col_range.each do |col|
          map[Position.new(row, col)] = '#'
        end
      elsif a_col == b_col
        # Vertical
        col = a_col
        row_range = [a_row, b_row].min..[a_row, b_row].max

        row_range.each do |row|
          map[Position.new(row, col)] = '#'
        end
      else
        raise 'this shouldn\'t happen'
      end
    end
  end

  def offset_to_index(lengths, offset)
    i = 0
    current = 0

    while i < lengths.size
      return i if current == offset

      current += lengths[i]
      i += 1
    end

    raise 'this should not happen'
  end

  def determine_lengths(offsets)
    lengths = [1]

    offsets.uniq.sort.each_cons(2).each do |a, b|
      lengths << (b - a) - 1 if (b - a) > 1
      lengths << 1
    end

    lengths
  end

  def build_points(start, instructions)
    current = start
    points = [current]

    instructions.each do |i|
      current = current.move(i.direction, i.count)
      points << current
    end

    points
  end

  def direction_from_string(string)
    case string
    when 'U' then :up
    when 'R' then :right
    when 'D' then :down
    when 'L' then :left
    end
  end

  def direction_to_string(dir)
    case dir
    when :up then 'U'
    when :right then 'R'
    when :down then 'D'
    when :left then 'L'
    end
  end
end

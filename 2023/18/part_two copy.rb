require 'set'

module PartTwo
  extend self

  def example_solution
    952408144115
  end

  def actual_solution

  end

  def main(input)
    # instructions = input.split("\n").map do |line|
    #   hex = line.split(' ').last[2..-2]
    #
    #   direction =
    #     case hex[-1]
    #     when '0' then :right
    #     when '1' then :down
    #     when '2' then :left
    #     when '3' then :up
    #     end
    #
    #   Instruction.new(
    #     direction,
    #     hex[..-2].to_i(16)
    #   )
    # end

    instructions = input.split("\n").map do |line|
      direction, count, color = line.split(' ')

      Instruction.new(
        direction_from_string(direction),
        count.to_i
      )
    end

    points = build_points(instructions)

    # rows = [1] + determine_lengths(points.map { _1.row }) + [1]
    # cols = [1] + determine_lengths(points.map { _1.col }) + [1]

    row_min = points.map { _1.row }.min
    col_min = points.map { _1.col }.min

    rows = [1] * 9
    cols = [1] * 12

    # p rows
    # p cols

    map = Map.empty(rows.size, cols.size) do |p|
      # [:up, :right, :down, :left]
      [
        p.row > 0 ? :up : nil,
        p.col < cols.size - 1 ? :right : nil,
        p.row < rows.size - 1 ? :down : nil,
        p.col > 0 ? :left : nil
      ].compact
    end

    build_wall_map(map, rows, cols, row_min, col_min, points)

    outside = Set.new
    fill(map, Position.new(0, 0), outside)

    map.each do |pos|
      if outside.include? pos
        map[pos] = '.'
      else
        map[pos] = '#'
      end
    end

    map.print

    # pos = Position.new(0, 0)
    # last = Position.new(1, 1)
    # instructions.each do |instruction|
    #   pos = pos.move(instruction.direction, instruction.count)
    #
    #   i_pos = position_to_index(pos, rows, cols)
    #   l_pos = Position.new(i_pos.row - last.row, i_pos.col - last.col)
    #   last = i_pos
    #
    #   puts "#{instruction.direction} #{l_pos.inspect}"
    # end

    area = map.each.sum do |pos, _|
      next 0 if outside.include? pos
      p pos

      rows[pos.row] * cols[pos.col]
    end

    edge_length = instructions.sum do |instruction|
      instruction.count
    end

    area + edge_length
  end

  private

  Instruction = Struct.new(:direction, :count)

  def build_wall_map(map, rows, cols, row_min, col_min, points)
    points.each_cons(2) do |a, b|
      a_row = offset_to_index(rows, row_min, a.row + 1)
      a_col = offset_to_index(cols, col_min, a.col + 1)

      b_row = offset_to_index(rows, row_min, b.row + 1)
      b_col = offset_to_index(cols, col_min, b.col + 1)

      if a_row == b_row
        # Horizontal
        row = a_row
        col_range = [a_col, b_col].min...[a_col, b_col].max

        # p [row, col_range]

        col_range.each do |col|
          map[Position.new(row - 1, col)] -= [:down] if row - 1 >= 0
          map[Position.new(row, col)] -= [:up] if row <= map.rows - 1
        end
      elsif a_col == b_col
        # Vertical
        col = a_col
        row_range = [a_row, b_row].min...[a_row, b_row].max

        # p [row_range, col]

        row_range.each do |row|
          map[Position.new(row, col - 1)] -= [:right] if col - 1 >= 0
          map[Position.new(row, col)] -= [:left] if col <= map.cols - 1
        end
      else
        raise 'this shouldn\'t happen'
      end
    end
  end

  def position_to_index(position, rows, cols)
    row = offset_to_index(rows, position.row + 1)
    col = offset_to_index(cols, position.col + 1)

    Position.new(row, col)
  end

  def offset_to_index(lengths, min, offset)
    i = 0
    current = min

    while i < lengths.size
      return i if current == offset

      current += lengths[i]
      i += 1
    end

    raise 'this should not happen'
  end

  def fill(map, current, visited)
    visited.add current

    # p map[current]

    map[current].each do |direction|
      new = current.move(direction)
      next if visited.include? new

      fill(map, new, visited)
    end
  end

  def determine_lengths(offsets)
    offsets.uniq.sort.each_cons(2).map { |a, b| b - a }
  end

  def build_points(instructions)
    current = Position.new(0, 0)
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
end

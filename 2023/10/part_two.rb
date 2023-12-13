require 'set'

module PartTwo
  extend self

  def example_solution
    10
  end

  def actual_solution
    449
  end

  def main(input)
    map = Map.new(input.split("\n").map { _1.chars })
    fill_map = Map.empty(map.rows * 2, map.cols * 2) { '.' }

    start = map.find { _1 == 'S' }
    current = start
    direction = nil

    loop do
      previous = current
      from_direction = direction

      direction = next_direction(map, current, from_direction)
      current = current.move(direction)

      position_in_fill_map = Position.new(previous.row * 2, previous.col * 2)
      fill_map.set(position_in_fill_map.move(direction, 1), '8')
      fill_map.set(position_in_fill_map.move(direction, 2), '8')

      break if current == start
    end

    fill_map.edge_positions.each do |edge|
      fill_map.flood_fill(edge) do |position|
        fill_map.at(position) == '.' ? 'O' : nil
      end
    end

    inside_count = 0
    fill_map.each do |position, value|
      if value == '.' && position.row % 2 == 0 && position.col % 2 == 0
        inside_count += 1
        fill_map.set(position, 'I')
      end
    end

    inside_count
  end

  private

  def next_direction(map, current_position, from_direction = nil)
    connected_directions = pipe_directions(map.at(current_position))

    connected_directions.find do |direction|
      next false if from_direction && direction == opposite_direction(from_direction)

      other_symbol = map.at(current_position.move(direction))
      next false unless other_symbol

      pipe_directions(other_symbol).include? opposite_direction(direction)
    end
  end

  def opposite_direction(direction)
    case direction
    when :up then :down
    when :right then :left
    when :down then :up
    when :left then :right
    end
  end

  def pipe_directions(symbol)
    case symbol
    when 'S' then [:up, :right, :down, :left]
    when '|' then [:up, :down]
    when '-' then [:left, :right]
    when 'L' then [:up, :right]
    when 'J' then [:up, :left]
    when '7' then [:down, :left]
    when 'F' then [:right, :down]
    when '.' then []
    end
  end
end

Position = Struct.new(:row, :col) do
  def left
    move :left
  end

  def right
    move :right
  end

  def up
    move :up
  end

  def down
    move :down
  end

  def move(direction, steps = 1)
    case direction
    when :up then Position.new(row - steps, col)
    when :down then Position.new(row + steps, col)
    when :left then Position.new(row, col - steps)
    when :right then Position.new(row, col + steps)
    end
  end
end

class Map
  def self.empty(rows, cols)
    new_grid = rows.times.map do |row|
      cols.times.map do |col|
        yield Position.new(row, col)
      end
    end

    Map.new(new_grid)
  end

  def initialize(grid)
    @grid = grid
  end

  def rows
    @grid.size
  end

  def cols
    @grid[0].size
  end

  def map
    new_grid = @grid.map do |row|
      @grid[row].map do |col|
        yield @grid[row][col]
      end
    end

    Map.new(new_grid)
  end

  def find
    @grid.each_index do |row|
      @grid[row].each_index do |col|
        return Position.new(row, col) if yield @grid[row][col]
      end
    end
  end

  def each
    @grid.each_index do |row|
      @grid[row].each_index do |col|
        yield Position.new(row, col), @grid[row][col]
      end
    end
  end

  def at(position)
    return unless in_map? position

    @grid[position.row][position.col]
  end

  def set(position, value)
    return unless in_map? position

    @grid[position.row][position.col] = value
  end

  def adjacent_positions_to(position)
    [position.up, position.right, position.down, position.left]
      .select { in_map? _1 }
  end

  def in_map?(position)
    position.row >= 0 && position.row < @grid.size &&
    position.col >= 0 && position.col < @grid[0].size
  end

  def flood_fill(position)
    stack = [position]
    filled = Set.new

    while stack.size > 0
      position = stack.pop
      to_fill_with = yield position

      if to_fill_with
        set position, to_fill_with

        adjacent = adjacent_positions_to(position).reject { filled.include? _1 }
        stack.concat(adjacent)
      end
    end

    filled
  end

  def edge_positions
    edges = []

    rows.times do |row|
      edges << Position.new(row, 0)
      edges << Position.new(row, cols - 1)
    end

    cols.times do |col|
      next if col == 0 || col == cols - 1

      edges << Position.new(0, col)
      edges << Position.new(rows - 1, col)
    end

    edges
  end

  def to_s
    @grid.map { _1.join('') }.join("\n")
  end

  def print
    puts self.to_s
  end
end

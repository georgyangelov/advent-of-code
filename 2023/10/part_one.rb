module PartOne
  extend self

  def example_solution
    8
  end

  def actual_solution
    6806
  end

  def main(input)
    map = Map.new(input.split("\n").map { _1.chars })

    start = map.find { _1 == 'S' }
    current = start
    from_direction = nil
    steps = 0

    loop do
      direction = next_direction(map, current, from_direction)
      current = current.move(direction)
      from_direction = direction

      break if current == start

      steps += 1
    end

    (steps.to_f / 2).ceil
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
  def initialize(grid)
    @grid = grid
  end

  def find
    @grid.each_index do |row|
      @grid[row].each_index do |col|
        return Position.new(row, col) if yield @grid[row][col]
      end
    end
  end

  def at(position)
    return unless in_map? position

    @grid[position.row][position.col]
  end

  def adjacent_positions_to(position)
    [position.up, position.right, position.down, position.left]
      .select { in_map? _1 }
  end

  def in_map?(position)
    position.row >= 0 && position.row < @grid.size &&
    position.col >= 0 && position.col < @grid[0].size
  end
end

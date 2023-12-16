module PartTwo
  extend self

  def example_solution
    51
  end

  def actual_solution
    7342
  end

  def main(input)
    map = input.split("\n").map { _1.chars }

    options = [
      *map[0].size.times.map { |col| [[0, col], :down] },
      *map[0].size.times.map { |col| [[map.size - 1, col], :up] },
      *map.size.times.map { |row| [[row, 0], :right] },
      *map.size.times.map { |row| [[row, map[0].size - 1], :left] }
    ].map { |position, direction| solve_from(map, position, direction) }.max
    
  end

  private

  def solve_from(map, position, direction)
    current = [[position, direction]]
    visited = {}
    energized = {}

    while current.size > 0
      position, direction = current.shift
      #p position
      next unless in_bounds? position, map
      next if visited[[position, direction]]
      visited[[position, direction]] = true
      energized[position] = true

      c = map[position[0]][position[1]]

      case c
      when '.', '<', '>', '^', 'v' then current.push next_in_direction(position, direction)
      when '/', '\\' then current.push next_in_direction(position, next_direction_for_mirror(c, direction))
      when '-'
        case direction
        when :left then current.push next_in_direction(position, direction)
        when :right then current.push next_in_direction(position, direction)
        when :up, :down
          current.push next_in_direction(position, :left)
          current.push next_in_direction(position, :right)
        end
      when '|'
        case direction
        when :up then current.push next_in_direction(position, direction)
        when :down then current.push next_in_direction(position, direction)
        when :left, :right
          current.push next_in_direction(position, :up)
          current.push next_in_direction(position, :down)
        end
      end
    end

    energized.size
  end

  def next_direction_for_mirror(mirror, direction)
    case mirror
    when '/'
      case direction
      when :left then :down
      when :right then :up
      when :down then :left
      when :up then :right
      end
    when '\\'
      case direction
      when :right then :down
      when :down then :right
      when :left then :up
      when :up then :left
      end
    end
  end

  def next_in_direction(position, direction)
    row, col = position

    new_position = 
    case direction
    when :up then [row - 1, col]
    when :right then [row, col + 1]
    when :down then [row + 1, col]
    when :left then [row, col - 1]
    end

    [new_position, direction]
  end

  def in_bounds?(position, map)
    row, col = position

    row >= 0 && row < map.size &&
      col >= 0 && col < map[0].size
  end
end

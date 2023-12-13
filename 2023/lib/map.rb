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

  def distance_to(other)
    (row - other.row).abs + (col - other.col).abs
  end
end

class Map
  attr_reader :grid

  def self.empty(rows, cols)
    new_grid = rows.times.map do |row|
      cols.times.map do |col|
        yield Position.new(row, col)
      end
    end

    Map.new(new_grid)
  end

  def self.from_string(string)
    Map.new(string.split("\n").map { _1.chars })
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

  def each_row
    return enum_for(:each_row) unless block_given?

    @grid.each_index do |row|
      yield row, @grid[row]
    end
  end

  def each_col
    return enum_for(:each_col) unless block_given?

    @grid[0].each_index do |col|
      yield col, @grid.size.times.map { |i| @grid[i][col] }
    end
  end

  def each
    return enum_for(:each) unless block_given?

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

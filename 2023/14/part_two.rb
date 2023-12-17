module PartTwo
  extend self

  def example_solution
    64
  end

  def actual_solution

  end

  def main(input)
    grid = input.split("\n").map { _1.chars }

    # weight shift_right(grid.reverse.transpose)

    # grid = grid.reverse.transpose
    # previous_grid = grid

    # puts '---'
    # puts grid.map { _1.join('') }

    # grid = spin_cycle(grid)

    # puts '---'
    # puts grid.map { _1.join('') }

    # shift_up grid
    # puts grid.map { _1.join('') }
    # return weight grid

    cycles = {}

    100_000.times do |i|
      if i % 1_000 == 0
        puts i
        p cycles

        p cycles.select { |k, v| v > 10 }.map(&:first).uniq.sort
      end
      grid = spin_cycle(grid)
      w = weight(grid)

      cycles[w] ||= 0
      cycles[w] += 1

      # break if grid == previous_grid
      # previous_grid = grid

      # puts '---'
      # puts grid.map { _1.join('') }
    end

    puts cycles

    weight grid
  end

  private

  def rotate_right(grid)
    grid.reverse.transpose
  end

  def rotate_left(grid)
    grid.transpose.reverse
  end

  def spin_cycle(grid)
    # North
    # grid = rotate_right(grid)
    grid = shift_up(grid)

    # West
    # grid = rotate_right(grid)
    grid = shift_left(grid)

    # South
    # grid = rotate_right(grid)
    grid = shift_down(grid)

    # East
    # grid = rotate_right(grid)
    grid = shift_right(grid)

    grid
  end

  def shift_right(grid)
    grid.each do |row|
      slots = []

      (row.size-1).downto(0).each do |i|
        case row[i]
        when '.' then slots << i
        when '#' then slots = []
        when 'O'
          slot = slots.shift

          if slot
            row[slot] = 'O'
            row[i] = '.'
            slots << i
          end
        end
      end
    end

    grid
  end

  def shift_left(grid)
    grid.each do |row|
      slots = []

      0.upto(row.size-1).each do |i|
        case row[i]
        when '.' then slots << i
        when '#' then slots = []
        when 'O'
          slot = slots.shift

          if slot
            row[slot] = 'O'
            row[i] = '.'
            slots << i
          end
        end
      end
    end

    grid
  end

  def shift_up(grid)
    row_max_i = grid.size - 1
    col_max_i = grid[0].size - 1

    0.upto(col_max_i).each do |col|
      slots = []

      0.upto(row_max_i).each do |row|
        case grid[row][col]
        when '.' then slots << row
        when '#' then slots = []
        when 'O'
          slot = slots.shift

          if slot
            grid[slot][col] = 'O'
            grid[row][col] = '.'
            slots << row
          end
        end
      end
    end

    grid
  end

  def shift_down(grid)
    row_max_i = grid.size - 1
    col_max_i = grid[0].size - 1

    0.upto(col_max_i).each do |col|
      slots = []

      row_max_i.downto(0).each do |row|
        case grid[row][col]
        when '.' then slots << row
        when '#' then slots = []
        when 'O'
          slot = slots.shift

          if slot
            grid[slot][col] = 'O'
            grid[row][col] = '.'
            slots << row
          end
        end
      end
    end

    grid
  end

  def weight(grid)
    weight = 0

    row_max_i = grid.size - 1
    col_max_i = grid[0].size - 1

    0.upto(col_max_i).each do |col|
      row_max_i.downto(0).each do |row|
        weight += row_max_i + 1 - row if grid[row][col] == 'O'
      end
    end

    # grid.each do |row|
    #   row.each_with_index do |cell, i|
    #     weight += i + 1 if cell == 'O'
    #   end
    # end

    weight
  end
end

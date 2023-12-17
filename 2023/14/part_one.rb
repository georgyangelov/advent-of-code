module PartOne
  extend self

  def example_solution
    136
  end

  def actual_solution
    107142
  end

  def main(input)
    grid = input.split("\n").map { _1.chars }

    # puts grid.transpose.map { _1.join('') }
    #
    # puts '---'
    #
    # puts shift_right(grid.reverse.transpose).map { _1.join('') }

    weight shift_right(grid.reverse.transpose)
  end

  private

  def shift_right(grid)
    new_grid = []

    grid.each do |row|
      row = row.dup
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

      new_grid << row
    end

    new_grid
  end

  def weight(grid)
    weight = 0

    grid.each do |row|
      row.each_with_index do |cell, i|
        weight += i + 1 if cell == 'O'
      end
    end

    weight
  end
end

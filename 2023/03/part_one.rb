module PartOne
  extend self

  SYMBOLS = /[^.0-9]/

  def example_solution
    4361
  end

  def actual_solution
    532331
  end

  def main(input)
    map = input.split("\n").map { _1.chars }

    read_numbers(map) #.map { _1[:number] }
      .select { adjacent_to_symbol?(map, _1) }
      .map { _1[:number].to_i }
      .sum
  end

  private

  def read_numbers(map)
    numbers = []

    map.each.with_index do |row, row_index|
      position = nil
      number = ''

      row.each.with_index do |c, col_index|
        position = [row_index, col_index] if number == ''

        if c =~ /[0-9]/
          number << c
        elsif number != ''
          numbers << { number: number, position: position }
          number = ''
        end
      end

      if number != ''
        numbers << { number: number, position: position }
        number = ''
      end
    end

    numbers
  end

  def adjacent_to_symbol?(map, number)
    start_row = number[:position][0] - 1
    end_row = number[:position][0] + 1

    start_column = number[:position][1] - 1
    end_column = number[:position][1] + number[:number].size

    (start_row..end_row).to_a.product((start_column..end_column).to_a)
      .select { in_map?(map, _1) }
      .any? { |(row, column)| map[row][column] =~ SYMBOLS }
  end

  def in_map?(map, position)
    position[0] >= 0 and position[0] < map.size and
    position[1] >= 0 and position[1] < map[0].size
  end
end

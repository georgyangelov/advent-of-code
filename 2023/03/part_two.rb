module PartTwo
  extend self

  def example_solution
    467835
  end

  def actual_solution
    82301120
  end

  def main(input)
    map = input.split("\n").map { _1.chars }

    numbers = read_numbers(map)
    gears = find_gears(map)

    gears
      .map do |gear|
        {
          gear: gear,
          numbers: numbers.select { adjacent_to_gear?(_1, gear) }
        }
      end
      .select { _1[:numbers].size == 2 }
      .map { _1[:numbers].map { |num| num[:number].to_i }.reduce(:*) }
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

  def find_gears(map)
    gears = []

    map.each.with_index do |row, row_index|
      row.each.with_index do |c, col_index|
        gears << [row_index, col_index] if c == '*'
      end
    end

    gears
  end

  def adjacent_to_gear?(number, gear)
    adjacent_positions(number).include? gear
  end

  def adjacent_positions(number)
    start_row = number[:position][0] - 1
    end_row = number[:position][0] + 1

    start_column = number[:position][1] - 1
    end_column = number[:position][1] + number[:number].size

    (start_row..end_row).to_a.product((start_column..end_column).to_a)
  end
end

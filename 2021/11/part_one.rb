module PartOne
  extend self

  def example_solution
    1656
  end

  def actual_solution
    1681
  end

  def main(input)
    parsed_input = input.split("\n").map do |line|
      line.chars.map(&:to_i)
    end

    solve parsed_input
  end

  def solve(matrix)
    100.times.map { simulate_step(matrix) }.sum
  end

  private

  def simulate_step(matrix)
    each_cell matrix do |row, col|
      matrix[row][col] += 1
    end

    flashes = 0

    loop do
      octopus_flashed = false

      each_cell matrix do |row, col|
        next unless matrix[row][col] && matrix[row][col] > 9

        octopus_flashed = true
        flashes += 1
        matrix[row][col] = nil

        each_adjacent_cell matrix, row, col do |adjacent_row, adjacent_col|
          unless matrix[adjacent_row][adjacent_col].nil?
            matrix[adjacent_row][adjacent_col] += 1
          end
        end
      end

      break unless octopus_flashed
    end

    each_cell matrix do |row, col|
      matrix[row][col] = 0 if matrix[row][col].nil?
    end

    flashes
  end

  def each_cell(matrix)
    matrix.each_index do |row|
      matrix[row].each_index do |col|
        yield row, col
      end
    end
  end

  def each_adjacent_cell(matrix, row, col)
    maxCol = matrix[row].length - 1
    maxRow = matrix.length - 1

    yield row - 1, col - 1 if row > 0 && col > 0
    yield row - 1, col     if row > 0
    yield row - 1, col + 1 if row > 0 && col < maxCol
    yield row, col - 1     if col > 0
    yield row, col + 1     if col < maxCol
    yield row + 1, col - 1 if row < maxRow && col > 0
    yield row + 1, col     if row < maxRow
    yield row + 1, col + 1 if row < maxRow && col < maxCol
  end
end

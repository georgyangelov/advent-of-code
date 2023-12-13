require_relative '../lib/map'

module PartTwo
  extend self

  EXPANSION_RATE = 1_000_000

  def example_solution
    82000210
  end

  def actual_solution
    613686987427
  end

  def main(input)
    map = Map.from_string(input)

    expanded_rows = map.each_row.select { |i, values| values.all? { _1 == '.' } }.map(&:first)
    expanded_cols = map.each_col.select { |i, values| values.all? { _1 == '.' } }.map(&:first)

    positions_of_galaxies = map.each.select { |_, value| value == '#' }.map(&:first)

    positions_of_galaxies.combination(2).map do |a, b|
      expanded_row_factor = expanded_rows.count { |row| [a.row, b.row].min < row && row < [a.row, b.row].max }
      expanded_col_factor = expanded_cols.count { |col| [a.col, b.col].min < col && col < [a.col, b.col].max }

      a.distance_to(b) +
        expanded_row_factor * (EXPANSION_RATE - 1) +
        expanded_col_factor * (EXPANSION_RATE - 1)
    end.sum
  end

  private

end

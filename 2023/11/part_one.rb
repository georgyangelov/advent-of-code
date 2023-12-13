require_relative '../lib/map'

module PartOne
  extend self

  def example_solution
    374
  end

  def actual_solution
    9214785
  end

  def main(input)
    map = Map.from_string(input)
    # rows_to_duplicate = map.each_row.select { |i, values| values.all? { _1 == '.' } }.map(&:first)
    # cols_to_duplicate = map.each_col.select { |i, values| values.all? { _1 == '.' } }.map(&:first)

    map = Map.new(expand_empty_cols(expand_empty_rows(map.grid)))

    positions_of_galaxies = map.each.select { |_, value| value == '#' }.map(&:first)

    positions_of_galaxies.combination(2).map { _1.distance_to(_2) }.sum
  end

  private

  def expand_empty_rows(grid)
    expanded_grid = []

    grid.each do |values|
      expanded_grid << values if values.all? { _1 == '.' }
      expanded_grid << values
    end

    expanded_grid
  end

  def expand_empty_cols(grid)
    expand_empty_rows(grid.transpose).transpose
  end
end

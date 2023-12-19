require_relative '../lib/map'

module PartOne
  extend self

  def example_solution
    102
  end

  def actual_solution

  end

  def main(input)
    map = Map.from_string(input) { _1.to_i }

    find_path(map, Position.new(0, 0), Position.new(map.rows - 1, map.cols - 1))
  end

  private

  def find_path(map, from, to)
    notes = {}

    map.rows.each do |row|
      map.cols.each do |col|
        pos = Position.new(row, col)
        notes[pos] ||= {}
        notes[pos][:left] = [nil, nil, nil, nil]
        notes[pos][:right] = [nil, nil, nil, nil]
        notes[pos][:up] = [nil, nil, nil, nil]
        notes[pos][:down] = [0, 0, 0, 0]
      end
    end

    unvisited = [from]

    while current = unvisited.shift
      [:left, :right, :up, :down].each do |current_direction|
        [:left, :right, :up, :down]
          .select { can_move_in_direction? current_direction, , _1 }
      end
    end
  end

  def can_move_in_direction?(from_direction, consecutive, direction)
    direction != opposite_direction(from_direction) && (
      consecutive < 3 || from_direction != direction
    )
  end

  class CellState
    DIRECTIONS = [:up, :right, :down, :left]

    def initialize
      @states = [
        nil, nil, nil, nil,
        nil, nil, nil, nil,
        nil, nil, nil, nil,
        nil, nil, nil, nil,
      ]
    end

    def each_direction_and_index

    end
  end
end

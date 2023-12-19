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
    notes = {
      from => {
        right: { distance: 0, consecutive: -1, from: nil, from_direction: nil },
        down: { distance: 0, consecutive: -1, from: nil, from_direction: nil }
      }
    }

    unvisited = Set.new([from])

    while current = unvisited.min_by { notes[_1][:distance] }
      unvisited.delete current

      notes[current].each do |from_direction, note|
        # p current, note

        # break if current == to

        [:left, :up, :right, :down]
          .select { can_move_in_direction? from_direction, note[:consecutive], _1 }
          .each do |direction|
            position = current.move(direction)

            next unless map.in_map? position

            notes[position] ||= {}

            next_note = notes[position][direction]
            next_distance = note[:distance] + map[current]

            if !next_note || next_note[:distance] > next_distance
              notes[position][direction] = {
                distance: next_distance,
                from: current,
                direction: direction,
                from_direction: from_direction,
                consecutive: direction == from_direction ? note[:consecutive] + 1 : 1
              }

              unvisited.add position
            end
          end
      end
    end

    marks = map.map { _1 }

    current = to
    current_note = notes[to].values.min_by { _1[:distance] }
    loop do
      break if current == from

      marks[current] =
        case current_note[:direction]
        when :left then '<'
        when :up then '^'
        when :right then '>'
        when :down then 'v'
        end

      current = current_note[:from]
      current_note = notes[current][current_note[:from_direction]]
    end

    marks.print

    notes[to].values.map { _1[:distance] }.min - map[from] + map[to]
  end

  def can_move_in_direction?(from_direction, consecutive, direction)
    direction != opposite_direction(from_direction) && (
      consecutive < 3 || from_direction != direction
    )
  end
end

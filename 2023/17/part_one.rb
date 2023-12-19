require_relative '../lib/map'

module PartOne
  extend self

  def example_solution
    102
  end

  def actual_solution
    1004
  end

  def main(input)
    map = Map.from_string(input) { _1.to_i }

    # find_path(map, Position.new(0, 0), Position.new(map.rows - 1, map.cols - 1))
  end

  private

  def find_path(map, from, to)
    notes = {}

    states = Set.new([
      State.new(from, :right, 0, 0)
    ])

    end_states = []

    distances = {}

    while current = states.min_by { _1[:distance] }
      states.delete current

      [:left, :up, :right, :down]
        .select { can_move_in_direction? current[:direction], current[:consecutive], _1 }
        .each do |direction|
          position = current[:position].move(direction)

          next unless map.in_map? position

          consecutive = direction == current[:direction] ? current[:consecutive] + 1 : 1
          current_min_distance = distances[[position, direction, consecutive]]
          distance = current[:distance] + map[position]

          if !current_min_distance || distance < current_min_distance
            next_state = State.new(
              position,
              direction,
              consecutive,
              distance
            )

            distances[[position, direction, consecutive]] = distance
            states.add next_state

            end_states.push(next_state) if position == to
          end
        end
    end

    p end_states.min_by { _1[:distance] }[:distance]
  end

  def can_move_in_direction?(from_direction, consecutive, direction)
    direction != opposite_direction(from_direction) && (
      consecutive < 3 || from_direction != direction
    )
  end

  State = Struct.new(:position, :direction, :consecutive, :distance)
end

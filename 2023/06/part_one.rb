module PartOne
  extend self

  def example_solution
    288
  end

  def actual_solution
    781200
  end

  def main(input)
    times, records = input.split("\n")
      .map { _1.scan(/\d+/).map(&:to_i) }

    races = times.zip(records).map { |(time, record)| Race.new(time, record) }

    races.map { ways_to_win(_1) }.reduce(:*)
  end

  private

  Race = Struct.new(:time, :record)

  def ways_to_win(race)
    (0..race.time).count { |hold_time| hold_time * (race.time - hold_time) > race.record }
  end
end

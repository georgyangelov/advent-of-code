require 'set'

module PartOne
  extend self

  def example_solution
    35
  end

  def actual_solution
    331445006
  end

  def main(input)
    seeds = input[/seeds: (.+)/, 1].split(' ').map(&:to_i)

    maps = [
      parse_map(input, 'seed-to-soil'),
      parse_map(input, 'soil-to-fertilizer'),
      parse_map(input, 'fertilizer-to-water'),
      parse_map(input, 'water-to-light'),
      parse_map(input, 'light-to-temperature'),
      parse_map(input, 'temperature-to-humidity'),
      parse_map(input, 'humidity-to-location')
    ]

    seeds.map do |seed|
      maps.reduce(seed) { |number, map| map.convert(number) }
    end.min
  end

  private

  def parse_map(input, map_name)
    ranges = input[/#{map_name} map:\n(.+?)(\n\n|\z)/m, 1]
      .split("\n")
      .map { Range.new(*_1.split(' ').map(&:to_i)) }

    RangeMap.new(ranges)
  end

  Range = Struct.new(:destination_start, :source_start, :length) do
    def convert(number)
      offset = number - source_start

      return nil unless offset >= 0 and offset < length

      destination_start + offset
    end
  end

  class RangeMap
    def initialize(ranges)
      @ranges = ranges
    end

    def convert(number)
      @ranges.map { |range| range.convert(number) }.compact.first || number
    end
  end
end

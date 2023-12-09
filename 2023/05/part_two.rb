require 'set'

module PartTwo
  extend self

  def example_solution
    46
  end

  def actual_solution
    6472060
  end

  def main(input)
    seed_areas = input[/seeds: (.+)/, 1]
      .split(' ')
      .map(&:to_i)
      .each_slice(2)
      .map { |(start, length)| Area.new([start...(start + length)]) }

    maps = [
      parse_map(input, 'seed-to-soil'),
      parse_map(input, 'soil-to-fertilizer'),
      parse_map(input, 'fertilizer-to-water'),
      parse_map(input, 'water-to-light'),
      parse_map(input, 'light-to-temperature'),
      parse_map(input, 'temperature-to-humidity'),
      parse_map(input, 'humidity-to-location')
    ]

    seed_areas.map do |seed_area|
      maps.reduce(seed_area) { |area, map| map.convert(area) }
    end.map(&:min_value).min
  end

  private

  def parse_map(input, map_name)
    ranges = input[/#{map_name} map:\n(.+?)(\n\n|\z)/m, 1]
      .split("\n")
      .map { RangeMapping.new(*_1.split(' ').map(&:to_i)) }

    RangeMap.new(ranges)
  end

  class RangeMap
    def initialize(range_mappings)
      @range_mappings = range_mappings
    end

    def convert(area)
      translator = AreaTranslator.new(area)

      @range_mappings.each do |mapping|
        translator.translate(mapping.source_range, mapping.destination_range)
      end

      translator.final
    end
  end

  RangeMapping = Struct.new(:destination_start, :source_start, :length) do
    def source_range
      source_start...(source_start + length)
    end

    def destination_range
      destination_start...(destination_start + length)
    end
  end

  class AreaTranslator
    def initialize(area)
      @from = area
      @to = Area.new([])
    end

    def translate(source, destination)
      @from.ranges.each do |range|
        intersection = source.intersect(range)

        next unless intersection

        offset = intersection.min - source.min
        length = intersection.max - intersection.min + 1

        mapped_range = (destination.min + offset)..(destination.min + offset + length - 1)

        @from = @from.exclude_range(source)
        @to = @to.add_range(mapped_range)
      end
    end

    def final
      @to.add_ranges(@from.ranges)
    end
  end

  class Area
    attr_reader :ranges

    def initialize(ranges)
      @ranges = ranges.sort_by { _1.min }
    end

    def intersect(other)
      @ranges.map { |range| range.intersect(other) }.compact
    end

    def exclude_range(range)
      ranges = @ranges.flat_map { _1.exclude(range) }.compact

      Area.new(ranges)
    end

    def add_range(range)
      result = exclude_range(range)
      result.ranges << range
      result
    end

    def add_ranges(ranges)
      ranges.reduce(self) { |area, range| area.add_range(range) }
    end

    def exclude_ranges(ranges)
      ranges.reduce(self) { |area, range| area.exclude_range(range) }
    end

    def min_value
      @ranges.map(&:min).min
    end
  end
end

class Range
  def intersect(other)
    out_start = [self.min, other.min].max
    out_end = [self.max, other.max].min

    return nil unless out_start <= out_end

    (out_start..out_end)
  end

  def exclude(other)
    compact_invalid_ranges [
      (self.min...[self.max, other.min].min),
      ([self.min, other.max + 1].max..self.max)
    ]
  end
end

def compact_invalid_ranges(ranges)
  ranges.reject { |range| range.min == nil }
end

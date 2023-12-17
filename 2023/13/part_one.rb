module PartOne
  extend self

  def example_solution
    405
  end

  def actual_solution
    28651
  end

  def main(input)
    maps = input.split("\n\n").map { _1.split("\n").map(&:chars) }

    # puts maps[0].map { _1.join('') }
    # puts '---'
    # puts maps[0].transpose.map { _1.join('') }
    # find_row_symmetry(maps[0].transpose)

    maps.map do |map|
      vertical_index = find_row_symmetry(map.transpose)
      horizontal_index = find_row_symmetry(map)

      #if horizontal_index && vertical_index
        # puts '---------'
        # puts map.map { _1.join("") }
        #puts '---------'
        #puts map.transpose.map { _1.join("") }

        # puts "Size: #{map[0].size}x#{map.size}"

        # puts "Horizontal: #{horizontal_index}, Vertical: #{vertical_index}"
      #end

      (vertical_index || 0) + (100 * (horizontal_index || 0))
    end.sum
  end

  private

  def find_row_symmetry(map)
    (1..(map.size-1)).find do |i|
      span = [i, map.size - i].min

      before_indexes = (i - 1).downto(i - span)
      after_indexes = i.upto(i + span - 1)

      # if before_indexes.size != after_indexes.size
      #   p before_indexes, after_indexes
      #   puts '---'
      # end

      differences = 0

      matches = before_indexes.zip(after_indexes).each do |i1, i2|
        differences += difference_of(map[i1], map[i2])
      end

      differences == 0
    end
  end

  def difference_of(row1, row2)
    differences = 0

    row1.zip(row2).each { |a, b| differences += (a == b ? 0 : 1) }

    differences
  end
end

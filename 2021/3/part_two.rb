def solve(input)
  oxygen_input = filter_iteratively(input) do |values, bit_index|
    common_comparison = common_bits(values)[bit_index]
    target_bit_value = common_comparison >= 0 ? 1 : 0

    values.select { |value| value[bit_index] == target_bit_value }
  end

  p to_dec(oxygen_input)

  co2_input = filter_iteratively(input) do |values, bit_index|
    common_comparison = common_bits(values)[bit_index]
    target_bit_value = common_comparison < 0 ? 1 : 0

    values.select { |value| value[bit_index] == target_bit_value }
  end

  p to_dec(co2_input)

  to_dec(oxygen_input[0]) * to_dec(co2_input[0])
end

def filter_iteratively(values)
  current = values

  (0...values[0].size).each do |bit_index|
    current = yield current, bit_index

    break if current.size == 1
  end

  current
end

def common_bits(values)
  return if values.empty?

  bit_count = values.size

  sums = values.reduce([0] * values[0].size) do |sum, value|
    sum.zip(value).map { |a, b| a + b }
  end

  sums.map do |one_count|
    one_count <=> bit_count - one_count
  end
end

def to_dec(array_of_bits)
  array_of_bits.join('').to_i(2)
end

# p solve(File.read('./example.txt').split("\n").compact.map { |line| line.chars.map(&:to_i) })
p solve(File.read('./input.txt').split("\n").compact.map { |line| line.chars.map(&:to_i) })

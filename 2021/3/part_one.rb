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

def solve(input)
  common_bits = common_bits(input)

  gamma = common_bits.map { |common| common > 0 ? 1 : 0 }
  epsilon = common_bits.map { |common| common < 0 ? 1 : 0 }

  to_dec(gamma) * to_dec(epsilon)
end

p solve(File.read('./input.txt').split("\n").compact.map { |line| line.chars.map(&:to_i) })
# p solve(File.read('./input.txt').split("\n"))

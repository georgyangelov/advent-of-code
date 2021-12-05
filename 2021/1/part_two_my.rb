def solve(input)
  input.split("\n").map(&:to_i).each_cons(3).map(&:sum).each_cons(2).count { |a, b| b > a }
end

p solve(File.read('./input.txt'))

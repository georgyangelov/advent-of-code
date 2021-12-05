def solve(n, b)
  h=->(n,l){n.size-n.reverse.find_index{|n|l.include? n}-1}
  f=->(n,b){[*b,*b.transpose].map{|line|h[n,line]}.min}
  l,i = b.map{|b|[b,f[n,b]]}.max_by{|_,i|i}
  n[i]*(l.flatten-n[0..i]).sum
end

n, *b = File.read('./input.txt').split("\n\n")
n = n.split(',').map(&:to_i)
b = b.map do |board|
  board
    .split("\n")
    .map { |line| line.split(' ').map(&:to_i) }
end

p solve(n, b)

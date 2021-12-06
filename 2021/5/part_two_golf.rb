module PartTwo
  extend self

  def example_solution
    12
  end

  def actual_solution
    19771
  end

  def main(input)
    lines = input.split("\n").map do |line|
      line.split('->').map { |vector| vector.split(',').map(&:to_i) }
    end

    solve lines
  end

  def solve(l)
    l.flat_map{|l|
      (x,y),(a,b)=l.sort
      ([(a-x).abs,(b-y).abs].max+1).times.map{|i|[x+i*(a<=>x),y+i*(b<=>y)]}
    }.tally.count{|_,c|c>1}
  end
end

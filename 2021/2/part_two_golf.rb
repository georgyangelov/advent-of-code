def solve(i)
  h,d,a=0,0,0;i.each{|c|c=~/(.) (.+)/;n=$2.to_i;$1==?d?(h+=n;d+=a*n): $1==?n?a+=n: a-=n};h*d
end


p solve(File.read('./input.txt').split("\n"))

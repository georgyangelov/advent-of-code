def solve(n)
  f=->(v=n.map{|n|n.to_i 2},t){i=11;loop{s=v.map{|v|v[i]}.sum;d=2*s>=v.size ? t:1-t;v=v.select{|v|v[i]==d};break if v.size==1;i-=1};v[0]}
  f[1]*f[0]
end

p solve(File.read('./input.txt').split("\n").compact)

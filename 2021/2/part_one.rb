def solve(commands)
  horizontal, depth = commands.reduce([0, 0]) do |(horizontal, depth), command|
    case command
    when /forward (.+)/ then [horizontal + $1.to_i, depth]
    when /down (.+)/ then [horizontal, depth + $1.to_i]
    when /up (.+)/ then [horizontal, depth - $1.to_i]
    end
  end

  horizontal * depth
end

p solve(File.read('./input.txt').split("\n"))

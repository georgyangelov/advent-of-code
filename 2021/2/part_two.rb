def solve(commands)
  horizontal, depth, _ = commands.reduce([0, 0, 0]) do |(horizontal, depth, aim), command|
    case command
    when /forward (.+)/ then [horizontal + $1.to_i, depth + aim * $1.to_i, aim]
    when /down (.+)/ then [horizontal, depth, aim + $1.to_i]
    when /up (.+)/ then [horizontal, depth, aim - $1.to_i]
    end
  end

  horizontal * depth
end

p solve(File.read('./input.txt').split("\n"))

def solve(numbers, boards)
  last_board, num_index = boards.map do |board|
    [board, board_match_location(numbers, board)]
  end.max_by { |_, i| i }

  number = numbers[num_index]

  number * (last_board.flatten - numbers[0..num_index]).sum
end

def board_match_location(numbers, board)
  [*board, *board.transpose].map{ |line| line_match_location(numbers, line) }.min
end

def line_match_location(numbers, line)
  numbers.size - 1 - numbers.reverse.find_index { |n| line.include? n }
end

numbers, *boards = File.read('./input.txt').split("\n\n")
numbers = numbers.split(',').map(&:to_i)
boards = boards.map do |board|
  board
    .split("\n")
    .map { |line| line.split(' ').map(&:to_i) }
end

p solve(numbers, boards)

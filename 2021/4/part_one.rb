def solve(numbers, boards)
  # mark_number(boards[0], 13)
  numbers.each do |number|
    boards = boards.map do |board|
      new_board = mark_number(board, number)

      return sum_unmarked(new_board) * number if solved? new_board

      new_board
    end
  end
end

def mark_number(board, drawn_number)
  board.map do |row|
    row.map do |(number, marked)|
      next [number, true] if number == drawn_number

      [number, marked]
    end
  end
end

def solved?(board)
  board.map do |row|
    return true if row.all? { |(_, marked)| marked }
  end

  board.transpose.map do |row|
    return true if row.all? { |(_, marked)| marked }
  end

  false
end

def sum_unmarked(board)
  board.map do |row|
    row.select { |(value, marked)| !marked }.map { |(value, _)| value }.sum
  end.sum
end

components = File.read('./input.txt').split("\n\n")
numbers = components[0].split(',').map(&:to_i)
boards = components.drop(1).map do |board|
  board
    .split("\n")
    .map { |line| line.split(' ').map(&:to_i).map { |n| [n, false] } }
end

p solve(numbers, boards)

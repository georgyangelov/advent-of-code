def solve(numbers, boards)
  result = nil

  numbers.each do |number|
    boards = boards.map do |board|
      new_board = mark_number(board, number)

      if solved? new_board
        result = sum_unmarked(new_board) * number
        next
      end

      new_board
    end.compact
  end

  result
end

def mark_number(board, drawn_number)
  board.map do |row|
    row.map do |number|
      if number == drawn_number
        nil
      else
        number
      end
    end
  end
end

def solved?(board)
  board.map do |row|
    return true if row.all?(&:nil?)
  end

  board.transpose.map do |row|
    return true if row.all?(&:nil?)
  end

  false
end

def sum_unmarked(board)
  board.map { |row| row.reject(&:nil?).sum }.sum
end

components = File.read('./input.txt').split("\n\n")
numbers = components[0].split(',').map(&:to_i)
boards = components.drop(1).map do |board|
  board
    .split("\n")
    .map { |line| line.split(' ').map(&:to_i) }
end

p solve(numbers, boards)

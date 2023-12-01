require_relative 'part_one'
require_relative 'part_two'

describe 'test' do
  describe 'part one' do
    it 'solves the example' do
      input = File.read('./part_one_example.txt').chomp

      expect(PartOne.main(input)).to eq PartOne.example_solution
    end

    it 'solves the real input' do
      input = File.read('./input.txt').chomp
      solution = PartOne.main(input)

      if PartOne.actual_solution
        expect(PartOne.main(input)).to eq PartOne.actual_solution
      else
        puts "Part One Solution: #{solution.inspect}"
      end
    end
  end

  if PartTwo.example_solution
    describe 'part two' do
      it 'solves the example' do
        input = File.read('./part_two_example.txt').chomp

        expect(PartTwo.main(input)).to eq PartTwo.example_solution
      end

      it 'solves the real input' do
        input = File.read('./input.txt').chomp
        solution = PartTwo.main(input)

        if PartTwo.actual_solution
          expect(PartTwo.main(input)).to eq PartTwo.actual_solution
        else
          puts "Part Two Solution: #{solution.inspect}"
        end
      end
    end
  end
end

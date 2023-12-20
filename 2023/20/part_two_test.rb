require 'set'

module PartTwo
  extend self

  def example_solution
    1
  end

  def actual_solution

  end

  def main(input)
    nodes = input.split("\n").map do |line|
      from, to = line.split(' -> ')
      name = from[/[a-z]+/].to_sym
      to = to.split(', ').map { _1.to_sym }

      node =
        case from[0]
        when '%' then FlipFlop.new(name, to, false)
        when '&' then Conjunction.new(name, to, {})
        else Broadcaster.new(name, to)
        end

      [name, node]
    end.to_h

    nodes[:button] = Broadcaster.new(:button, [:broadcaster])

    nodes.values.flat_map { _1.to_names }.map do |name|
      nodes[name] = Broadcaster.new(name, []) unless nodes[name]
    end

    nodes.values.each do |node|
      node.to_names.each do |to_name|
        to = nodes[to_name]
        to.states[node.name] = false if to.is_a? Conjunction
      end
    end

    cycles = []
    find_cycles nodes, :broadcaster, [], cycles

    puts(cycles.map do |cycle|
      cycle.join(' ')
    end)

    nil
  end

  private

  FlipFlop = Struct.new(:name, :to_names, :state)
  Conjunction = Struct.new(:name, :to_names, :states)
  Broadcaster = Struct.new(:name, :to_names)

  def find_cycles(nodes, start_name, path, cycles)
    if path.include? start_name
      # path << start_name
      # path = path.drop_while { _1 != start_name }
      # cycles << path
      return
    end

    if start_name == :rx
      path << start_name
      cycles << (path.map do |name|
        type =
          case nodes[name]
          when FlipFlop then '%'
          when Conjunction then '&'
          else ''
          end

        "#{type}#{name}"
      end)
      return
    end

    path << start_name

    nodes[start_name].to_names.each do |to_name|
      find_cycles(nodes, to_name, path.dup, cycles)
    end
  end
end

PartTwo.main File.read('input.txt')

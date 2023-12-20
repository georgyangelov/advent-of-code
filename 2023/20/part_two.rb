module PartTwo
  extend self

  def example_solution
    nil
  end

  def actual_solution
    243566897206981
  end

  def main(input)
    nodes = input.split("\n").map do |line|
      from, to = line.split(' -> ')
      name = from[/[a-z]+/].to_sym
      to = to.split(', ').map { _1.to_sym }

      node =
        case from[0]
        when '%' then FlipFlop.new(name, to)
        when '&' then Conjunction.new(name, to)
        else Broadcaster.new(name, to)
        end

      [name, node]
    end.to_h

    nodes[:button] = Broadcaster.new(:button, [:broadcaster])

    nodes.values.flat_map { _1.to_names }.map do |name|
      nodes[name] = Broadcaster.new(name, []) unless nodes[name]
    end

    # print_cycles(nodes)

    cycle_lengths = nodes[:broadcaster].to_names.map do |start|
      state = new_state(nodes)

      find_cycle_length(nodes, state, start, :zg, true)
    end

    cycle_lengths.reduce(&:lcm)
  end

  private

  FlipFlop = Struct.new(:name, :to_names)
  Conjunction = Struct.new(:name, :to_names)
  Broadcaster = Struct.new(:name, :to_names)

  def new_state(nodes)
    state = {}

    nodes.values.each do |node|
      case node
      when FlipFlop
        state[node.name] = false
      when Conjunction
        state[node.name] = {}
      end
    end

    nodes.values.each do |node|
      node.to_names.each do |to_name|
        to = nodes[to_name]

        state[to_name][node.name] = false if to.is_a? Conjunction
      end
    end

    state
  end

  def send_signal(nodes, state, from_node_name, signal, node_name, signals, target)
    pending = [[from_node_name, signal, node_name]]

    while pending.size > 0
      from_node_name, signal, node_name = pending.shift
      node = nodes[node_name]

      # puts "#{node_name} #{signal}"

      signals[signal] += 1 if node_name == target

      out =
        case node
        when FlipFlop
          if signal == false
            state[node_name] = !state[node_name]

            state[node_name]
          end
        when Conjunction
          state[node_name][from_node_name] = signal

          # p node.states

          !state[node_name].values.all? { _1 }
        when Broadcaster
          signal
        end

      if out != nil
        node.to_names.each do |to_name|
          pending << [node_name, out, to_name]
        end
      end
    end
  end

  def print_cycles(nodes)
    cycles = []
    find_paths nodes, :broadcaster, [], cycles

    puts '------------'
    puts(cycles.map do |cycle|
      cycle.join(' ')
    end)
    puts '------------'
  end

  def find_cycle_length(nodes, state, start, target, target_value)
    signals = { true => 0, false => 0 }
    presses = 0

    # target = :zg
    # target_value = true

    first_cycle_length = 0
    cycle_offset = 0
    cycle_length = 0
    current_length = 0
    cycle_count = 0

    loop do
      presses += 1
      current_length += 1

      send_signal(nodes, state, :button, false, start, signals, target)

      if signals[target_value] > 0
        signals[target_value] = 0
        cycle_length = current_length
        current_length = 0

        cycle_count += 1

        if first_cycle_length == 0
          first_cycle_length = cycle_length
        end
      end

      break if cycle_count >= 2
    end

    puts "Cycle count: #{cycle_count}"
    puts "Cycle length: #{cycle_length}"
    puts "Cycle offset: #{first_cycle_length - cycle_length}"

    cycle_length
  end

  def find_paths(nodes, start_name, path, result)
    if path.include? start_name
      # path << start_name
      # path = path.drop_while { _1 != start_name }
      # result << path
      return
    end

    if start_name == :rx
      path << start_name
      result << (path.map do |name|
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
      find_paths(nodes, to_name, path.dup, result)
    end
  end
end

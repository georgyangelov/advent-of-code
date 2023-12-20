module PartOne
  extend self

  def example_solution
    11687500
  end

  def actual_solution
    825896364
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

    signals = { true => 0, false => 0 }

    1000.times do
      send_signal(nodes, :button, false, :broadcaster, signals)
    end

    p signals

    signals[true] * signals[false]
  end

  private

  FlipFlop = Struct.new(:name, :to_names, :state)
  Conjunction = Struct.new(:name, :to_names, :states)
  Broadcaster = Struct.new(:name, :to_names)

  def send_signal(nodes, from_node_name, signal, node_name, signals)
    pending = [[from_node_name, signal, node_name]]

    while pending.size > 0
      from_node_name, signal, node_name = pending.shift
      node = nodes[node_name]

      # puts "#{node_name} #{signal}"

      signals[signal] += 1

      out =
        case node
        when FlipFlop
          if signal == false
            node.state = !node.state

            node.state
          end
        when Conjunction
          node.states[from_node_name] = signal

          # p node.states

          !node.states.values.all? { _1 }
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
end

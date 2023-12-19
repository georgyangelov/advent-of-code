module PartTwo
  extend self

  def example_solution
    167409079868000
  end

  def actual_solution
    130251901420382
  end

  def main(input)
    worflow, _ = input.split("\n\n")

    rules = worflow.split("\n").map do |line|
      match = line.match(/(.+)\{(.+)\}/)
      name = match[1]
      cases = match[2].split(',').map do |condition|
        if condition.include? ':'
          component, operator, value, label = condition.match(/([a-z]+)([<>])([0-9]+):([a-z]+)/i).captures

          Conditional.new(component.to_sym, operator.to_sym, value.to_i, label.to_sym)
        else
          Jump.new(condition.to_sym)
        end
      end

      [name.to_sym, Rule.new(cases)]
    end.to_h

    part = {
      x: 1..4000,
      m: 1..4000,
      a: 1..4000,
      s: 1..4000
    }

    combinations = []

    accepted_combinations(part, rules, :in, combinations)

    combinations.map do |combination|
      combination.values.map(&:count).reduce(:*)
    end.sum
  end

  private

  Conditional = Struct.new(:component, :operator, :value, :label)
  Jump = Struct.new(:label)
  Rule = Struct.new(:cases)

  def accepted_combinations(part, rules, label, combinations)
    if label == :A
      combinations << part
      return
    elsif label == :R
      return
    end

    rule = rules[label]
    rule.cases.each do |c|
      if c.is_a? Jump
        accepted_combinations(part, rules, c.label, combinations)
      else
        true_range, false_range = split_range(part[c.component], c.operator, c.value)

        if true_range
          true_part = part.clone
          true_part[c.component] = true_range

          accepted_combinations(true_part, rules, c.label, combinations)
        end

        break unless false_range

        part[c.component] = false_range
      end
    end
  end

  def split_range(range, operator, value)
    if value < range.min
      if operator == :<
        [nil, range]
      else
        [range, nil]
      end
    elsif value > range.max
      if operator == :<
        [range, nil]
      else
        [nil, range]
      end
    else
      if operator == :<
        r = range.min...value
        [r.count > 0 ? r : nil, value..range.max]
      else
        r = (value + 1)..range.max
        [r.count > 0 ? r : nil, range.min..value]
      end
    end
  end
end

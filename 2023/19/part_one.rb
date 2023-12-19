module PartOne
  extend self

  def example_solution
    19114
  end

  def actual_solution
    420739
  end

  def main(input)
    worflow, parts = input.split("\n\n")

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

    parts = parts.split("\n").map do |part|
      components = part.scan(/([a-z]+)=(\d+)/i)
        .map { [_1.to_sym, _2.to_i] }
        .to_h

      Part.new(components)
    end

    parts
      .select { part_accepted? _1, rules }
      .map { _1.total_ratings }
      .sum
  end

  private

  Conditional = Struct.new(:component, :operator, :value, :label) do
    def match?(part)
      operator == :< && part.components[component] < value ||
      operator == :> && part.components[component] > value
    end
  end

  Jump = Struct.new(:label) do
    def match?(part)
      true
    end
  end

  Rule = Struct.new(:cases)
  Part = Struct.new(:components) do
    def total_ratings
      components.values.sum
    end
  end

  def part_accepted?(part, rules)
    label = :in

    while label != :A && label != :R
      rule = rules[label]
      label = rule.cases.find { |c| c.match? part }.label
    end

    label == :A
  end
end

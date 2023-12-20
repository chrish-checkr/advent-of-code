INPUT_FILENAME = "day19-input.txt"

class Day19Solver
  def initialize
    @workflows = []
    @parts = []
    File.open(INPUT_FILENAME).each_with_index do |row|
      row = row.strip
      if row.start_with?("{")
        @parts << eval(row.gsub("=",": "))
      elsif !row.empty?
        row_sections = row.gsub("}","").split("{")
        @workflows << {
          key: row_sections[0],
          conditions: row_sections[1].split(",")
        }
      end
    end

    @possible_routes = []
  end

  def solve_part_one
    accepts = []
    @parts.each do |part|
      current_workflow_key = "in"

      while !["A", "R"].include?(current_workflow_key) do
        current_workflow = @workflows.find do |workflow|
          workflow[:key] == current_workflow_key
        end

        current_workflow[:conditions].each do |condition|
          if condition.include?("<")
            c = condition.split(/<|:/)
            if part[c[0].to_sym] < c[1].to_i
              current_workflow_key = c[2]
              break
            end
          elsif condition.include?(">")
            c = condition.split(/>|:/)
            if part[c[0].to_sym] > c[1].to_i
              current_workflow_key = c[2]
              break
            end
          else
            current_workflow_key = condition
            break
          end
        end
      end

      accepts << part if current_workflow_key == "A"
    end

    sum = 0
    accepts.each do |part|
      sum += [part[:x],part[:m],part[:a],part[:s]].sum
    end
    puts sum
  end

  # Part Two

  def solve_part_two
    evaluate_route("in", [])
    
    all_ranges = []
    @possible_routes.each do |route|
      ranges = { x: (1..4_000).to_a, m: (1..4_000).to_a, a: (1..4_000).to_a, s: (1..4_000).to_a }

      route.each do |condition|
        if condition.include?("<")
          c = condition.split(/<|:/)
          ranges[c[0].to_sym] = ranges[c[0].to_sym] & (1..(c[1].to_i - 1)).to_a
        elsif condition.include?(">")
          c = condition.split(/>|:/)
          ranges[c[0].to_sym] = ranges[c[0].to_sym] & ((c[1].to_i + 1)..4_000).to_a
        end
      end

      all_ranges << ranges
    end

    puts @possible_routes.to_s

    sum = 0
    all_ranges.each do |range|
      sum += range.values.map(&:count).inject(:*)
    end
    puts sum
  end

  def evaluate_route(workflow_key, current_route)
    current_workflow = @workflows.find do |workflow|
      workflow[:key] == workflow_key
    end

    current_workflow[:conditions].each_with_index do |condition,idx|
      this_route = current_route.dup

      next_node = nil
      if condition.include?("<")
        next_node = condition.split(/<|:/)[2]
      elsif condition.include?(">")
        next_node = condition.split(/>|:/)[2]
      else
        next_node = condition
      end

      # Negate previous instructions so they are all mutually exclusive
      if idx > 0
        (0..idx-1).each do |prev_idx|
          old_cond = current_workflow[:conditions][prev_idx]
          if old_cond.include?("<")
            old_cs = old_cond.split(/<|:/)
            this_route << "#{old_cs[0]}>#{old_cs[1].to_i-1}:#{old_cs[2]}"
          elsif old_cond.include?(">")
            old_cs = old_cond.split(/>|:/)
            this_route << "#{old_cs[0]}<#{old_cs[1].to_i+1}:#{old_cs[2]}"
          else
            raise "Should not hit this"
          end
        end
      end
      this_route << condition

      if next_node == "A"
        @possible_routes << this_route
      elsif next_node != "R"
        evaluate_route(next_node.dup, this_route)
      end
    end
  end
end

solver = Day19Solver.new
solver.solve_part_one
solver.solve_part_two


INPUT_FILENAME = "day12-test.txt"

class Day12Solver
  def initialize
    @rows = []
    File.open(INPUT_FILENAME).each do |row|
      next if row.strip == ""

      parts = row.split(/\s/)

      @rows << {
        springs: parts[0],
        groups: parts[1].split(",").map(&:to_i)
      }
    end

    @possible_answers = []
  end

  def solve_part_one
    @rows.each do |row|
      queue = [[row[:springs], row[:groups]]]

      while !queue.empty?
        springs, groups = queue.shift
        possibilities = solve_next_unknown(springs, groups)
        queue = queue.concat(possibilities)
      end
    end

    puts @possible_answers.count
  end

  def solve_next_unknown(springs, groups)
    if !springs.include?("?")
      @possible_answers << springs
      # puts "ANSWER: #{springs}, #{groups}"
      return []
    end

    # Now figure out what the next one could be
    possibilities = []
    [".", "#"].each do |new_char|
      new_springs = springs.sub("?",new_char)

      new_groups = []
      prev_char = nil
      possible = true
      current_group_size = 0
      hit_question_mark_yet = false

      new_springs.chars.each do |char|
        if char == "#"
          current_group_size += 1
        elsif [".", "?"].include?(char) && prev_char == "#"
          new_groups << current_group_size
          if (!hit_question_mark_yet && new_groups.count > groups.count) ||
              (!hit_question_mark_yet && (groups[new_groups.count - 1] < current_group_size))
            possible = false
            break
          end
          current_group_size = 0
        end
        hit_question_mark_yet = true if char == "?"
        prev_char = char
      end

      new_groups << current_group_size if current_group_size > 0

      if !new_springs.include?("?") && new_groups != groups
        possible = false
      end

      if possible
        possibilities << new_springs
      end
    end

    possibilities.map do |possible_spring|
      [possible_spring, groups]
    end
  end
end

Day12Solver.new.solve_part_one

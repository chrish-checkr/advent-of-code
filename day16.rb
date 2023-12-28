INPUT_FILENAME = "day16-input.txt"

# Part One

cells = {}

File.open(INPUT_FILENAME).each_with_index do |row, y_idx|
  row.strip.chars.each_with_index do |char, x_idx|
    cells[[x_idx,y_idx]] = char
  end
end

# puts cells.to_s
energized_counts = []
queue = [[[0,0], [1,0]]]
visited = []
while !queue.empty?
  next_move = queue.shift
  next if visited.include?(next_move)

  next_char = cells[next_move[0]]
  next if next_char.nil?

  visited << next_move

  keep_going = [[next_move[0], next_move[1]].transpose.map(&:sum), next_move[1]]

  if next_char == "."
    queue << keep_going
  elsif next_char == "/"
    queue << mirror = [[next_move[0], next_move[1].reverse.map { |c| -1*c }].transpose.map(&:sum), next_move[1].reverse.map { |c| -1*c }]
  elsif next_char == "\\"
    queue << mirror = [[next_move[0], next_move[1].reverse].transpose.map(&:sum), next_move[1].reverse]
  elsif next_char == "-"
    if [[-1,0],[1,0]].include?(next_move[1])
      queue << keep_going
    else
      # split
      [[-1,0],[1,0]].each do |split_move|
        queue << [[next_move[0], split_move].transpose.map(&:sum), split_move]
      end
    end
  elsif next_char == "|"
    if [[0,-1],[0,1]].include?(next_move[1])
      queue << keep_going
    else
      # split
      [[0,-1],[0,1]].each do |split_move|
        queue << [[next_move[0], split_move].transpose.map(&:sum), split_move]
      end
    end
  end
end

puts visited.map(&:first).uniq.count

# Part Two - just brute force it :/
# Probably wouldn't be hard to store previously visited paths between edge or non-"." cells and not have to visit the whole lot again every time

all_starts = []

(0..cells.keys.map(&:first).max).each do |x_idx|
  all_starts << [[x_idx, 0], [0,1]]
  all_starts << [[x_idx, cells.keys.map(&:first).max], [0,-1]]
end

(0..cells.keys.map(&:last).max).each do |y_idx|
  all_starts << [[0,y_idx], [1,0]]
  all_starts << [[cells.keys.map(&:last).max,y_idx], [-1,0]]
end

all_starts.each do |start|
  queue = [start]
  visited = []
  while !queue.empty?
    next_move = queue.shift
    next if visited.include?(next_move)

    next_char = cells[next_move[0]]
    next if next_char.nil?

    visited << next_move

    keep_going = [[next_move[0], next_move[1]].transpose.map(&:sum), next_move[1]]

    if next_char == "."
      queue << keep_going
    elsif next_char == "/"
      queue << mirror = [[next_move[0], next_move[1].reverse.map { |c| -1*c }].transpose.map(&:sum), next_move[1].reverse.map { |c| -1*c }]
    elsif next_char == "\\"
      queue << mirror = [[next_move[0], next_move[1].reverse].transpose.map(&:sum), next_move[1].reverse]
    elsif next_char == "-"
      if [[-1,0],[1,0]].include?(next_move[1])
        queue << keep_going
      else
        # split
        [[-1,0],[1,0]].each do |split_move|
          queue << [[next_move[0], split_move].transpose.map(&:sum), split_move]
        end
      end
    elsif next_char == "|"
      if [[0,-1],[0,1]].include?(next_move[1])
        queue << keep_going
      else
        # split
        [[0,-1],[0,1]].each do |split_move|
          queue << [[next_move[0], split_move].transpose.map(&:sum), split_move]
        end
      end
    end
  end

  energized_counts << visited.map(&:first).uniq.count
  puts energized_counts
end

puts energized_counts.max

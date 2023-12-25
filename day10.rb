INPUT_FILENAME = "day10-input.txt"

# Part One

sum = 0
nodes = {}
start_node = nil

File.open(INPUT_FILENAME).each_with_index do |row, y_idx|
  row.strip.chars.each_with_index do |char, x_idx|
    nodes[[x_idx,y_idx]] = char
    start_node = [x_idx,y_idx] if char == "S"
  end
end

queue = [start_node]
visited = []

while !queue.empty?
  current_node = queue.shift
  current_char = nodes[current_node]

  visited << current_node

  neighbors = [[-1,0],[1,0],[0,-1],[0,1]].map do |move|
    [
      [current_node, move].transpose.map(&:sum),
      move
    ]
  end

  neighbors.each do |neighbor, move|
    neighbor_char = nodes[neighbor]

    if !visited.include?(neighbor) && (
      (move == [1,0] && ["S","-","L","F"].include?(current_char) && ["S","-","7","J"].include?(neighbor_char)) ||
      (move == [-1,0] && ["S","-","7","J"].include?(current_char) && ["S","-","F","L"].include?(neighbor_char)) ||
      (move == [0,1] && ["S","|","7","F"].include?(current_char) && ["S","|","L","J"].include?(neighbor_char)) ||
      (move == [0,-1] && ["S","|","L","J"].include?(current_char) && ["S","|","7","F"].include?(neighbor_char))
    )
      queue << neighbor
      break
    end
  end
end

puts visited.count / 2

# Part Two

# Calculate the vertices, then calculate the area of the polygon, then subtract the number in "visited"
vertices = visited.select { |coords| ["F","L","7","J","S"].include?(nodes[coords]) } + [start_node]

# Shoelace algo - see Day 18 as well
sum = vertices.each_cons(2).sum { |a,b|
  a[0]*b[1] - b[0]*a[1]
}.abs/2 + (visited.count)/2 + 1

puts sum - visited.count

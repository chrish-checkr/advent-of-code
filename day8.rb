INPUT_FILENAME = "day8-input.txt"

# Part One
path = ""
nodes = {}
File.open(INPUT_FILENAME).each_with_index do |row, idx|
  path = row.strip if idx == 0

  if idx > 1
    node_parts = row.strip.gsub(" ","").gsub("(","").gsub(")","").split("=").flat_map { |parts| parts.split(",") }
    nodes[node_parts[0]] = {
      "L" => node_parts[1],
      "R" => node_parts[2]
    }
  end
end

steps = 0
result_found = false
current_node = "AAA"

while !result_found
  path.chars.each do |char|
    steps += 1
    # print "." if steps % 10_000 == 0

    current_node = nodes[current_node][char]
    if current_node == "ZZZ"
      result_found = true
      break
    end
  end
end

puts steps

puts "-" * 30

# Part Two
path = ""
nodes = {}
start_nodes = []

File.open(INPUT_FILENAME).each_with_index do |row, idx|
  path = row.strip if idx == 0

  if idx > 1
    node_parts = row.strip.gsub(" ","").gsub("(","").gsub(")","").split("=").flat_map { |parts| parts.split(",") }
    nodes[node_parts[0]] = {
      "L" => node_parts[1],
      "R" => node_parts[2]
    }

    start_nodes << node_parts[0] if node_parts[0].end_with?("A")
  end
end

step_counts = []
start_nodes.each do |node|
  steps = 0
  result_found = false
  current_node = node

  while !result_found
    path.chars.each do |char|
      steps += 1
      # print "." if steps % 10_000 == 0

      current_node = nodes[current_node][char]
      if current_node.end_with?("Z")
        result_found = true
        break
      end
    end
  end

  step_counts << steps
end

# lowest common multiple of all the individual step counts
puts step_counts.reduce(1, :lcm)

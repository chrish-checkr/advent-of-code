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
    print "." if steps % 1_000_000 == 0

    current_node = nodes[current_node][char]
    if current_node == "ZZZ"
      result_found = true
      break
    end
  end
end

puts steps

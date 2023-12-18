INPUT_FILENAME = "day18-input.txt"

# Part One
instructions = []

File.open(INPUT_FILENAME).each_with_index do |row|
  parts = row.split(" ")
  instructions << {
    dir: parts[0],
    dist: parts[1].to_i
  }
end

DIRECTIONS = {
  "U" => [0,-1],
  "D" => [0,1],
  "L" => [-1,0],
  "R" => [1,0]
}

current_index = [0,0]
hashes = [current_index]
instructions.each do |instruction|
  instruction[:dist].times do
    current_index = [current_index, DIRECTIONS[instruction[:dir]]].transpose.map(&:sum)
    hashes << current_index
  end
end

hashes = hashes.uniq

min_x = hashes.map(&:first).min
min_y = hashes.map(&:last).min
max_x = hashes.map(&:first).max
max_y = hashes.map(&:last).max

def is_inside?(hashes, x, y)
  return true if hashes.include?([x,y])

  earlier_x_groups = hashes.select { |idx| idx.first < x && idx.last == y }.map(&:first).sort.slice_when { |prev, curr| curr != prev.next }.to_a
  earlier_y_groups = hashes.select { |idx| idx.first == x && idx.last < y }.map(&:last).sort.slice_when { |prev, curr| curr != prev.next }.to_a

  x_open = false
  earlier_x_groups.each do |group|
    if group.size == 1
      x_open = !x_open 
    else
      x_open = !x_open unless (
        (hashes.include?([group.first,y-1]) && hashes.include?([group.last,y-1])) ||
        (hashes.include?([group.first,y+1]) && hashes.include?([group.last,y+1]))
      )
    end
  end

  y_open = false
  earlier_y_groups.each do |group|
    if group.size == 1
      y_open = !y_open 
    else
      y_open = !y_open unless (
        (hashes.include?([x-1,group.first]) && hashes.include?([x-1,group.last])) ||
        (hashes.include?([x+1,group.first]) && hashes.include?([x+1,group.last]))
      )
    end
  end

  x_open && y_open 
end

sum = 0
# Also draw it for fun
image_string = ""
prev_y = min_y
(min_y..max_y).each do |y|
  image_string << "\n" if y > prev_y
  prev_y = y
  (min_x..max_x).each do |x|
    if is_inside?(hashes, x, y)
      sum += 1
      image_string << "#"
    else
      image_string << "."
    end
  end
end

puts sum

File.write("day18-output-fill.txt", image_string)

# Part Two
instructions = []

P2_DIRECTIONS = [
  [1,0],
  [0,1],
  [-1,0],
  [0,-1]
]

File.open(INPUT_FILENAME).each_with_index do |row|
  parts = row.strip.gsub("(","").gsub(")","").split(" ")
  instructions << {
    dir: P2_DIRECTIONS[parts.last.chars.last.to_i],
    dist: parts.last[1..5].to_i(16)
  }
end

current_index = [0,0]
vertices = [current_index]
edge_length = 0
instructions.each do |instruction|
  current_index = [current_index, instruction[:dir].map { |coord| coord*instruction[:dist] }].transpose.map(&:sum)
  vertices << current_index
  edge_length += instruction[:dist]
end

vertices = vertices.uniq

# Shoelace algo
sum = vertices.each_cons(2).sum { |a,b|
  a[0]*b[1] - b[0]*a[1]
}.abs/2 + edge_length/2 + 1

puts sum

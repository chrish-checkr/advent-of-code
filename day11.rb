INPUT_FILENAME = "day11-input.txt"

# Part One

expanded_rows = []

File.open(INPUT_FILENAME).each do |row|
  count = row.strip.chars.all? { |char| char == "." } ? 2 : 1
  count.times do
    expanded_rows << row.strip.chars
  end
end

expanded_columns = []
expanded_rows.transpose.each do |column|
  count = column.all? { |char| char == "." } ? 2 : 1
  count.times do
    expanded_columns << column.dup
  end
end

galaxies = []
expanded_columns.transpose.each_with_index do |row, y_idx|
  row.each_with_index do |char, x_idx|
    galaxies << [x_idx,y_idx] if char == "#"
  end
end

sum = 0
galaxies.combination(2).each do |pair|
  sum += (pair[1][0] - pair[0][0]).abs + (pair[1][1] - pair[0][1]).abs
end

puts sum

# Part Two

galaxies = []
all_rows = []
empty_row_indexes = []
empty_column_indexes = []

File.open(INPUT_FILENAME).each_with_index do |row, y_idx|
  chars = row.strip.chars

  all_rows << chars

  chars.each_with_index do |char, x_idx|
    galaxies << [x_idx,y_idx] if char == "#"
  end

  empty_row_indexes << y_idx if chars.all? { |char| char == "." }
end

all_rows.transpose.each_with_index do |column, x_idx|
  empty_column_indexes << x_idx if column.all? { |char| char == "." }
end

puts empty_row_indexes.to_s
puts empty_column_indexes.to_s

puts galaxies.to_s

x_bumps = Hash.new(0)
empty_column_indexes.each do |x_idx|
  galaxies.each do |galaxy|
    x_bumps[galaxy] += 1 if galaxy[0] > x_idx
  end
end

y_bumps = Hash.new(0)
empty_row_indexes.each do |y_idx|
  galaxies.each do |galaxy|
    y_bumps[galaxy] += 1 if galaxy[1] > y_idx
  end
end

sum = 0
galaxies.map { |galaxy| [galaxy[0] + (1_000_000-1)*x_bumps[galaxy], galaxy[1] + (1_000_000-1)*y_bumps[galaxy]] }.combination(2).each do |pair|
  sum += (pair[1][0] - pair[0][0]).abs + (pair[1][1] - pair[0][1]).abs
end
puts sum

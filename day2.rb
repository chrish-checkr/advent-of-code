INPUT_FILENAME = "day2-input.txt"

# Part One

sum = 0

File.open(INPUT_FILENAME).each do |row|
  game_number = row.scan(/Game\s\d*[:]/).first.gsub(/[^0-9]/, '').to_i
  max_blue = row.scan(/\d*\sblue/).map { |str| str.gsub(/[^0-9]/, '').to_i }.max
  max_red = row.scan(/\d*\sred/).map { |str| str.gsub(/[^0-9]/, '').to_i }.max
  max_green = row.scan(/\d*\sgreen/).map { |str| str.gsub(/[^0-9]/, '').to_i }.max

  if max_red <= 12 && max_green <= 13 && max_blue <= 14
    sum += game_number
  end
end

puts sum

# Part Two

sum = 0

File.open(INPUT_FILENAME).each do |row|
  max_blue = row.scan(/\d*\sblue/).map { |str| str.gsub(/[^0-9]/, '').to_i }.max
  max_red = row.scan(/\d*\sred/).map { |str| str.gsub(/[^0-9]/, '').to_i }.max
  max_green = row.scan(/\d*\sgreen/).map { |str| str.gsub(/[^0-9]/, '').to_i }.max

  sum += max_red * max_green * max_blue
end

puts sum

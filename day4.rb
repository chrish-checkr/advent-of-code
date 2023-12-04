INPUT_FILENAME = "day4-input.txt"

# Part One

sum = 0

File.open(INPUT_FILENAME).each do |row|
  res = row.strip.split(":").last.split("|").map { |segment| segment.split(" ") }
  overlap = (res[0] & res[1]).size
  sum += 2 ** (overlap - 1) unless overlap == 0
end

puts sum

# Part Two

sum = 0

card_counts = Hash.new(0)

File.open(INPUT_FILENAME).each do |row|
  card_num = row.strip.split(":").first.split(" ").last.to_i
  card_counts[card_num] += 1

  res = row.strip.split(":").last.split("|").map { |segment| segment.split(" ") }
  overlap = (res[0] & res[1]).size
  unless overlap == 0
    (1..overlap).each do |num|
      card_counts[card_num + num] += card_counts[card_num]
    end
  end
end

puts card_counts.values.sum

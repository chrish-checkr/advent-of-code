INPUT_FILENAME = "day7-input.txt"

# Part One
hands = []

File.open(INPUT_FILENAME).each do |row|
  input_parts = row.split(" ")
  hands << {
    hand: input_parts[0],
    bid: input_parts[1].to_i
  }
end

hands.each do |hand|
  freq = Hash.new(0)
  hand[:hand].chars.each do |char|
    freq[char] += 1
  end
  pairs = freq.values.sort.reverse
  hand[:type_val] = (2 * pairs[0]) + (pairs[1] || 1) - 1
  hand[:sort_chars] = hand[:hand].chars.map { |char| char.gsub("T","10").gsub("J","11").gsub("Q","12").gsub("K","13").gsub("A","14").to_i }
end

hands.sort_by! do |hand|
  [hand[:type_val]].concat(hand[:sort_chars])
end

sum = 0
hands.each_with_index do |hand, index|
  sum += (index + 1) * hand[:bid]
  # puts "#{(index + 1)} * #{hand[:bid]}"
end

puts sum

# Part Two
hands = []

File.open(INPUT_FILENAME).each do |row|
  input_parts = row.split(" ")
  hands << {
    hand: input_parts[0],
    bid: input_parts[1].to_i
  }
end

hands.each do |hand|
  freq = Hash.new(0)
  j_count = 0
  hand[:hand].chars.each do |char|    
    if char == "J"
      j_count += 1
    else
      freq[char] += 1
    end
  end
  pairs = freq.values.sort.reverse
  hand[:type_val] = (2 * ((pairs[0] || 0) + j_count)) + (pairs[1] || 1) - 1
  hand[:sort_chars] = hand[:hand].chars.map { |char| char.gsub("T","10").gsub("J","1").gsub("Q","12").gsub("K","13").gsub("A","14").to_i }
end

hands.sort_by! do |hand|
  [hand[:type_val]].concat(hand[:sort_chars])
end

sum = 0
hands.each_with_index do |hand, index|
  sum += (index + 1) * hand[:bid]
  # puts "#{(index + 1)} * #{hand[:bid]}"
end

puts sum

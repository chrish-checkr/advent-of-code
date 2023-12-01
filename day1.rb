INPUT_FILENAME = "day1-input.txt"
NUMBERS = {
  "oneight": 18,
  "threeight": 38,
  "fiveight": 58,
  "nineight": 98,
  "twone": 21,
  "eightwo": 82,
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9
}

sum = 0

File.open(INPUT_FILENAME).each do |row|
  NUMBERS.each do |k,v|
    row = row.gsub(k.to_s, v.to_s)
  end

  digits = row.gsub(/[^0-9]/, '')
  sum += [digits[0], digits[-1]].join.to_i
end

puts sum
